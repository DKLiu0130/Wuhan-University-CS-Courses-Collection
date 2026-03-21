#include <rthw.h>
#include <rtthread.h>
#include <stdint.h>

#define DBG_TAG           "kernel.buddy"
#define DBG_LVL           DBG_INFO
#include <rtdbg.h>

#ifdef RT_USING_BUDDY

#if 1
#define BUDDY_MAX_ORDER   16
#define BUDDY_BLOCK_HEADER_SIZE  (RT_ALIGN(sizeof(rt_uint32_t), RT_ALIGN_SIZE))

typedef struct rt_buddy_block {
    struct rt_buddy_block *next;
    rt_uint32_t order;
} rt_buddy_block_t;

#define BUDDY_BLOCK_SIZE(order)  ((rt_uint32_t)(RT_ALIGN_SIZE << (order)))
#define BUDDY_BLOCK_DATA(block)  ((rt_uint8_t *)(block) + BUDDY_BLOCK_HEADER_SIZE)
#define BUDDY_DATA_BLOCK(ptr)    ((rt_buddy_block_t *)((rt_uint8_t *)(ptr) - BUDDY_BLOCK_HEADER_SIZE))

struct rt_buddy {
    struct rt_memory parent;
    rt_uint8_t *heap_ptr;
    rt_uint32_t heap_size;
    rt_uint32_t min_order;
    rt_uint32_t max_order;
    rt_buddy_block_t *free_lists[BUDDY_MAX_ORDER + 1];
    rt_uint32_t used;
    rt_uint32_t max_used;
    rt_uint32_t total;
};

static rt_uint32_t buddy_get_order(rt_size_t size)
{
    rt_uint32_t order = 0;
    rt_size_t block_size = RT_ALIGN_SIZE;
    
    size = RT_ALIGN(size + BUDDY_BLOCK_HEADER_SIZE, RT_ALIGN_SIZE);
    
    while (block_size < size && order < BUDDY_MAX_ORDER) {
        order++;
        block_size <<= 1;
    }
    
    return order;
}

static rt_buddy_block_t *buddy_get_buddy(struct rt_buddy *buddy, rt_buddy_block_t *block, rt_uint32_t order)
{
    rt_ubase_t block_addr = (rt_ubase_t)block - (rt_ubase_t)buddy->heap_ptr;
    rt_ubase_t block_size = BUDDY_BLOCK_SIZE(order);
    rt_ubase_t buddy_addr = block_addr ^ block_size;
    
    if (buddy_addr >= buddy->heap_size || buddy_addr + block_size > buddy->heap_size) {
        return RT_NULL;
    }
    
    return (rt_buddy_block_t *)(buddy->heap_ptr + buddy_addr);
}

static void buddy_list_add(rt_buddy_block_t **list, rt_buddy_block_t *block)
{
    block->next = *list;
    *list = block;
}

static rt_buddy_block_t *buddy_list_remove(rt_buddy_block_t **list)
{
    rt_buddy_block_t *block = *list;
    if (block) {
        *list = block->next;
        block->next = RT_NULL;
    }
    return block;
}

rt_buddy_t rt_buddy_init(const char *name, void *start_addr, rt_size_t size)
{
    struct rt_buddy *buddy;
    rt_buddy_t buddy_handle;
    rt_ubase_t start_addr_aligned, begin_align, end_align, mem_size;
    rt_uint32_t order;
    rt_ubase_t block_size;
    
    start_addr_aligned = RT_ALIGN((rt_ubase_t)start_addr, RT_ALIGN_SIZE);
    begin_align = start_addr_aligned + sizeof(struct rt_buddy);
    begin_align = RT_ALIGN(begin_align, RT_ALIGN_SIZE);
    end_align = RT_ALIGN_DOWN((rt_ubase_t)start_addr + size, RT_ALIGN_SIZE);
    
    if (end_align <= begin_align || (end_align - begin_align) < (1UL << 8)) {
        return RT_NULL;
    }
    
    mem_size = end_align - begin_align;
    
    buddy = (struct rt_buddy *)start_addr_aligned;
    if ((rt_ubase_t)buddy + sizeof(struct rt_buddy) > end_align) {
        return RT_NULL;
    }
    
    rt_memset(buddy, 0, sizeof(struct rt_buddy));
    
    rt_object_init(&(buddy->parent.parent), RT_Object_Class_Memory, name);
    buddy->parent.algorithm = "buddy";
    buddy->parent.address = begin_align;
    buddy->parent.total = mem_size;
    
    order = 0;
    block_size = RT_ALIGN_SIZE;
    while (order < BUDDY_MAX_ORDER) {
        rt_ubase_t next_size = block_size << 1;
        if (next_size > mem_size) {
            break;
        }
        order++;
        block_size = next_size;
    }
    
    rt_ubase_t max_block_size = BUDDY_BLOCK_SIZE(order);
    rt_ubase_t heap_start = RT_ALIGN((rt_ubase_t)begin_align, max_block_size);
    if (heap_start >= end_align) {
        heap_start = begin_align;
    }
    rt_ubase_t actual_heap_size = end_align - heap_start;
    
    if (actual_heap_size < max_block_size) {
        order = 0;
        max_block_size = RT_ALIGN_SIZE;
        while (order < BUDDY_MAX_ORDER) {
            rt_ubase_t next_size = max_block_size << 1;
            if (next_size > actual_heap_size) {
                break;
            }
            order++;
            max_block_size = next_size;
        }
    }
    
    buddy->heap_ptr = (rt_uint8_t *)heap_start;
    buddy->heap_size = actual_heap_size;
    buddy->max_order = order;
    buddy->min_order = 0;
    
    buddy->parent.address = heap_start;
    buddy->parent.total = actual_heap_size;
    buddy->total = actual_heap_size;
    buddy->used = 0;
    buddy->max_used = 0;
    
    for (rt_uint32_t i = 0; i <= BUDDY_MAX_ORDER; i++) {
        buddy->free_lists[i] = RT_NULL;
    }
    
    max_block_size = BUDDY_BLOCK_SIZE(buddy->max_order);
    if (max_block_size <= buddy->heap_size && buddy->max_order >= buddy->min_order) {
        rt_buddy_block_t *first_block = (rt_buddy_block_t *)buddy->heap_ptr;
        rt_ubase_t first_block_end = (rt_ubase_t)first_block + max_block_size;
        rt_ubase_t heap_end = (rt_ubase_t)buddy->heap_ptr + buddy->heap_size;
        if (first_block_end <= heap_end) {
            rt_memset(first_block, 0, sizeof(rt_buddy_block_t));
            first_block->next = RT_NULL;
            first_block->order = buddy->max_order;
            buddy->free_lists[buddy->max_order] = first_block;
        }
    }
    
    buddy_handle = (rt_buddy_t)buddy;
    return buddy_handle;
}

void *rt_buddy_alloc(rt_buddy_t buddy_handle, rt_size_t size)
{
    struct rt_buddy *buddy = (struct rt_buddy *)buddy_handle;
    rt_uint32_t order;
    rt_uint32_t current_order;
    rt_buddy_block_t *block;
    
    if (buddy == RT_NULL || size == 0) {
        return RT_NULL;
    }
    
    order = buddy_get_order(size);
    if (order > buddy->max_order) {
        return RT_NULL;
    }
    
    current_order = order;
    while (current_order <= buddy->max_order) {
        if (buddy->free_lists[current_order] != RT_NULL) {
            block = buddy_list_remove(&buddy->free_lists[current_order]);
            
            while (current_order > order) {
                rt_ubase_t block_size = BUDDY_BLOCK_SIZE(current_order - 1);
                rt_buddy_block_t *buddy_block = (rt_buddy_block_t *)((rt_uint8_t *)block + block_size);
                rt_ubase_t buddy_block_addr = (rt_ubase_t)buddy_block - (rt_ubase_t)buddy->heap_ptr;
                
                if (buddy_block_addr + BUDDY_BLOCK_SIZE(current_order - 1) > buddy->heap_size) {
                    break;
                }
                
                rt_memset(buddy_block, 0, sizeof(rt_buddy_block_t));
                buddy_block->order = current_order - 1;
                buddy_block->next = RT_NULL;
                buddy_list_add(&buddy->free_lists[current_order - 1], buddy_block);
                current_order--;
            }
            
            block->order = current_order;
            buddy->used += BUDDY_BLOCK_SIZE(current_order);
            if (buddy->used > buddy->max_used) {
                buddy->max_used = buddy->used;
            }
            
            return BUDDY_BLOCK_DATA(block);
        }
        current_order++;
    }
    
    return RT_NULL;
}

static rt_bool_t buddy_list_find_and_remove(rt_buddy_block_t **list, rt_buddy_block_t *block)
{
    rt_buddy_block_t *curr = *list;
    rt_buddy_block_t *prev = RT_NULL;
    
    while (curr) {
        if (curr == block) {
            if (prev) {
                prev->next = curr->next;
            } else {
                *list = curr->next;
            }
            return RT_TRUE;
        }
        prev = curr;
        curr = curr->next;
    }
    return RT_FALSE;
}

void rt_buddy_free(rt_buddy_t buddy_handle, void *ptr)
{
    struct rt_buddy *buddy = (struct rt_buddy *)buddy_handle;
    rt_buddy_block_t *block;
    rt_buddy_block_t *buddy_block;
    rt_uint32_t order;
    
    if (buddy == RT_NULL || ptr == RT_NULL) {
        return;
    }
    
    block = BUDDY_DATA_BLOCK(ptr);
    rt_ubase_t block_addr = (rt_ubase_t)block - (rt_ubase_t)buddy->heap_ptr;
    if (block_addr >= buddy->heap_size) {
        return;
    }
    
    order = block->order;
    if (order > buddy->max_order) {
        return;
    }
    
    while (order < buddy->max_order) {
        buddy_block = buddy_get_buddy(buddy, block, order);
        
        if (buddy_block == RT_NULL) {
            break;
        }
        
        rt_ubase_t buddy_block_addr = (rt_ubase_t)buddy_block - (rt_ubase_t)buddy->heap_ptr;
        if (buddy_block_addr >= buddy->heap_size) {
            break;
        }
        
        if (buddy_block->order != order) {
            break;
        }
        
        if (!buddy_list_find_and_remove(&buddy->free_lists[order], buddy_block)) {
            break;
        }
        
        if ((rt_ubase_t)block > (rt_ubase_t)buddy_block) {
            block = buddy_block;
        }
        
        order++;
        block->order = order;
    }
    
    block->next = RT_NULL;
    block->order = order;
    buddy_list_add(&buddy->free_lists[order], block);
    
    buddy->used -= BUDDY_BLOCK_SIZE(order);
}

void *rt_buddy_realloc(rt_buddy_t buddy_handle, void *ptr, rt_size_t newsize)
{
    struct rt_buddy *buddy = (struct rt_buddy *)buddy_handle;
    rt_buddy_block_t *block;
    rt_uint32_t old_order;
    rt_uint32_t new_order;
    void *new_ptr;
    
    if (buddy == RT_NULL) {
        return RT_NULL;
    }
    
    if (ptr == RT_NULL) {
        return rt_buddy_alloc(buddy_handle, newsize);
    }
    
    if (newsize == 0) {
        rt_buddy_free(buddy_handle, ptr);
        return RT_NULL;
    }
    
    block = BUDDY_DATA_BLOCK(ptr);
    old_order = block->order;
    new_order = buddy_get_order(newsize);
    
    if (new_order > buddy->max_order) {
        return RT_NULL;
    }
    
    if (new_order == old_order) {
        return ptr;
    }
    
    new_ptr = rt_buddy_alloc(buddy_handle, newsize);
    if (new_ptr == RT_NULL) {
        return RT_NULL;
    }
    
    rt_uint32_t copy_size = BUDDY_BLOCK_SIZE(old_order) - BUDDY_BLOCK_HEADER_SIZE;
    rt_uint32_t new_size = BUDDY_BLOCK_SIZE(new_order) - BUDDY_BLOCK_HEADER_SIZE;
    if (copy_size > new_size) {
        copy_size = new_size;
    }
    
    rt_memcpy(new_ptr, ptr, copy_size);
    rt_buddy_free(buddy_handle, ptr);
    
    return new_ptr;
}

void rt_buddy_info(rt_buddy_t buddy_handle, rt_size_t *total, rt_size_t *used, rt_size_t *max_used)
{
    struct rt_buddy *buddy = (struct rt_buddy *)buddy_handle;
    
    if (buddy == RT_NULL) {
        if (total) *total = 0;
        if (used) *used = 0;
        if (max_used) *max_used = 0;
        return;
    }
    
    if (total) *total = buddy->total;
    if (used) *used = buddy->used;
    if (max_used) *max_used = buddy->max_used;
}
RTM_EXPORT(rt_buddy_init);
RTM_EXPORT(rt_buddy_alloc);
RTM_EXPORT(rt_buddy_free);
RTM_EXPORT(rt_buddy_realloc);
RTM_EXPORT(rt_buddy_info);
#endif

#if 0
struct rt_buddy_small_mem_item
{
    rt_ubase_t              pool_ptr;
    rt_size_t               next;
    rt_size_t               prev;
};

struct rt_buddy
{
    struct rt_memory            parent;
    rt_uint8_t                 *heap_ptr;
    struct rt_buddy_small_mem_item   *heap_end;
    struct rt_buddy_small_mem_item   *lfree;
    rt_size_t                   mem_size_aligned;
};

#define BUDDY_MIN_SIZE (sizeof(rt_ubase_t) + sizeof(rt_size_t) + sizeof(rt_size_t))

#define BUDDY_MEM_MASK ((~(rt_size_t)0) - 1)

#define BUDDY_MEM_USED(_mem)       ((((rt_base_t)(_mem)) & BUDDY_MEM_MASK) | 0x1)
#define BUDDY_MEM_FREED(_mem)      ((((rt_base_t)(_mem)) & BUDDY_MEM_MASK) | 0x0)
#define BUDDY_MEM_ISUSED(_mem)   \
                      (((rt_base_t)(((struct rt_buddy_small_mem_item *)(_mem))->pool_ptr)) & (~BUDDY_MEM_MASK))
#define BUDDY_MEM_POOL(_mem)     \
    ((struct rt_buddy *)(((rt_base_t)(((struct rt_buddy_small_mem_item *)(_mem))->pool_ptr)) & (BUDDY_MEM_MASK)))
#define BUDDY_MEM_SIZE(_heap, _mem)      \
    (((struct rt_buddy_small_mem_item *)(_mem))->next - ((rt_ubase_t)(_mem) - \
    (rt_ubase_t)((_heap)->heap_ptr)) - RT_ALIGN(sizeof(struct rt_buddy_small_mem_item), RT_ALIGN_SIZE))

#define BUDDY_MIN_SIZE_ALIGNED     RT_ALIGN(BUDDY_MIN_SIZE, RT_ALIGN_SIZE)
#define BUDDY_SIZEOF_STRUCT_MEM    RT_ALIGN(sizeof(struct rt_buddy_small_mem_item), RT_ALIGN_SIZE)

static void buddy_plug_holes(struct rt_buddy *m, struct rt_buddy_small_mem_item *mem)
{
    struct rt_buddy_small_mem_item *nmem;
    struct rt_buddy_small_mem_item *pmem;

    RT_ASSERT((rt_uint8_t *)mem >= m->heap_ptr);
    RT_ASSERT((rt_uint8_t *)mem < (rt_uint8_t *)m->heap_end);

    nmem = (struct rt_buddy_small_mem_item *)&m->heap_ptr[mem->next];
    if (mem != nmem && !BUDDY_MEM_ISUSED(nmem) &&
        (rt_uint8_t *)nmem != (rt_uint8_t *)m->heap_end)
    {
        if (m->lfree == nmem)
        {
            m->lfree = mem;
        }
        nmem->pool_ptr = 0;
        mem->next = nmem->next;
        ((struct rt_buddy_small_mem_item *)&m->heap_ptr[nmem->next])->prev = (rt_uint8_t *)mem - m->heap_ptr;
    }

    pmem = (struct rt_buddy_small_mem_item *)&m->heap_ptr[mem->prev];
    if (pmem != mem && !BUDDY_MEM_ISUSED(pmem))
    {
        if (m->lfree == mem)
        {
            m->lfree = pmem;
        }
        mem->pool_ptr = 0;
        pmem->next = mem->next;
        ((struct rt_buddy_small_mem_item *)&m->heap_ptr[mem->next])->prev = (rt_ubase_t)pmem - (rt_ubase_t)m->heap_ptr;
    }
}

rt_buddy_t rt_buddy_init(const char    *name,
                     void          *begin_addr,
                     rt_size_t      size)
{
    struct rt_buddy_small_mem_item *mem;
    struct rt_buddy *buddy;
    rt_ubase_t start_addr, begin_align, end_align, mem_size;

    buddy = (struct rt_buddy *)RT_ALIGN((rt_ubase_t)begin_addr, RT_ALIGN_SIZE);
    start_addr = (rt_ubase_t)buddy + sizeof(*buddy);
    begin_align = RT_ALIGN((rt_ubase_t)start_addr, RT_ALIGN_SIZE);
    end_align   = RT_ALIGN_DOWN((rt_ubase_t)begin_addr + size, RT_ALIGN_SIZE);

    if ((end_align > (2 * BUDDY_SIZEOF_STRUCT_MEM)) &&
        ((end_align - 2 * BUDDY_SIZEOF_STRUCT_MEM) >= start_addr))
    {
        mem_size = end_align - begin_align - 2 * BUDDY_SIZEOF_STRUCT_MEM;
    }
    else
    {
        return RT_NULL;
    }

    rt_memset(buddy, 0, sizeof(*buddy));
    rt_object_init(&(buddy->parent.parent), RT_Object_Class_Memory, name);
    buddy->parent.algorithm = "buddy";
    buddy->parent.address = begin_align;
    buddy->parent.total = mem_size;
    buddy->mem_size_aligned = mem_size;

    buddy->heap_ptr = (rt_uint8_t *)begin_align;

    mem        = (struct rt_buddy_small_mem_item *)buddy->heap_ptr;
    mem->pool_ptr = BUDDY_MEM_FREED(buddy);
    mem->next  = buddy->mem_size_aligned + BUDDY_SIZEOF_STRUCT_MEM;
    mem->prev  = 0;

    buddy->heap_end        = (struct rt_buddy_small_mem_item *)&buddy->heap_ptr[mem->next];
    buddy->heap_end->pool_ptr = BUDDY_MEM_USED(buddy);
    buddy->heap_end->next  = buddy->mem_size_aligned + BUDDY_SIZEOF_STRUCT_MEM;
    buddy->heap_end->prev  = buddy->mem_size_aligned + BUDDY_SIZEOF_STRUCT_MEM;

    buddy->lfree = (struct rt_buddy_small_mem_item *)buddy->heap_ptr;

    return (rt_buddy_t)buddy;
}
RTM_EXPORT(rt_buddy_init);

void *rt_buddy_alloc(rt_buddy_t m, rt_size_t size)
{
    rt_size_t ptr, ptr2;
    struct rt_buddy_small_mem_item *mem, *mem2;
    struct rt_buddy *buddy;

    if (size == 0)
        return RT_NULL;

    RT_ASSERT(m != RT_NULL);
    RT_ASSERT(rt_object_get_type(&m->parent) == RT_Object_Class_Memory);
    RT_ASSERT(rt_object_is_systemobject(&m->parent));

    buddy = (struct rt_buddy *)m;
    size = RT_ALIGN(size, RT_ALIGN_SIZE);

    if (size < BUDDY_MIN_SIZE_ALIGNED)
        size = BUDDY_MIN_SIZE_ALIGNED;

    if (size > buddy->mem_size_aligned)
    {
        return RT_NULL;
    }

    for (ptr = (rt_ubase_t)((rt_uint8_t *)buddy->lfree - buddy->heap_ptr);
         ptr <= buddy->mem_size_aligned - size;
         ptr = ((struct rt_buddy_small_mem_item *)&buddy->heap_ptr[ptr])->next)
    {
        mem = (struct rt_buddy_small_mem_item *)&buddy->heap_ptr[ptr];

        if ((!BUDDY_MEM_ISUSED(mem)) && (mem->next - (ptr + BUDDY_SIZEOF_STRUCT_MEM)) >= size)
        {
            if (mem->next - (ptr + BUDDY_SIZEOF_STRUCT_MEM) >=
                (size + BUDDY_SIZEOF_STRUCT_MEM + BUDDY_MIN_SIZE_ALIGNED))
            {
                ptr2 = ptr + BUDDY_SIZEOF_STRUCT_MEM + size;

                mem2       = (struct rt_buddy_small_mem_item *)&buddy->heap_ptr[ptr2];
                mem2->pool_ptr = BUDDY_MEM_FREED(buddy);
                mem2->next = mem->next;
                mem2->prev = ptr;

                mem->next = ptr2;

                if (mem2->next != buddy->mem_size_aligned + BUDDY_SIZEOF_STRUCT_MEM)
                {
                    ((struct rt_buddy_small_mem_item *)&buddy->heap_ptr[mem2->next])->prev = ptr2;
                }
                buddy->parent.used += (size + BUDDY_SIZEOF_STRUCT_MEM);
                if (buddy->parent.max < buddy->parent.used)
                    buddy->parent.max = buddy->parent.used;
            }
            else
            {
                buddy->parent.used += mem->next - ((rt_ubase_t)((rt_uint8_t *)mem - buddy->heap_ptr));
                if (buddy->parent.max < buddy->parent.used)
                    buddy->parent.max = buddy->parent.used;
            }
            mem->pool_ptr = BUDDY_MEM_USED(buddy);

            if (mem == buddy->lfree)
            {
                while (BUDDY_MEM_ISUSED(buddy->lfree) && buddy->lfree != buddy->heap_end)
                    buddy->lfree = (struct rt_buddy_small_mem_item *)&buddy->heap_ptr[buddy->lfree->next];

                RT_ASSERT(((buddy->lfree == buddy->heap_end) || (!BUDDY_MEM_ISUSED(buddy->lfree))));
            }
            RT_ASSERT((rt_ubase_t)mem + BUDDY_SIZEOF_STRUCT_MEM + size <= (rt_ubase_t)buddy->heap_end);
            RT_ASSERT((rt_ubase_t)((rt_uint8_t *)mem + BUDDY_SIZEOF_STRUCT_MEM) % RT_ALIGN_SIZE == 0);
            RT_ASSERT((((rt_ubase_t)mem) & (RT_ALIGN_SIZE - 1)) == 0);

            return (rt_uint8_t *)mem + BUDDY_SIZEOF_STRUCT_MEM;
        }
    }

    return RT_NULL;
}
RTM_EXPORT(rt_buddy_alloc);

void *rt_buddy_realloc(rt_buddy_t m, void *rmem, rt_size_t newsize)
{
    rt_size_t size;
    rt_size_t ptr, ptr2;
    struct rt_buddy_small_mem_item *mem, *mem2;
    struct rt_buddy *buddy;
    void *nmem;

    RT_ASSERT(m != RT_NULL);
    RT_ASSERT(rt_object_get_type(&m->parent) == RT_Object_Class_Memory);
    RT_ASSERT(rt_object_is_systemobject(&m->parent));

    buddy = (struct rt_buddy *)m;
    newsize = RT_ALIGN(newsize, RT_ALIGN_SIZE);
    if (newsize > buddy->mem_size_aligned)
    {
        return RT_NULL;
    }
    else if (newsize == 0)
    {
        rt_buddy_free(m, rmem);
        return RT_NULL;
    }

    if (rmem == RT_NULL)
        return rt_buddy_alloc(m, newsize);

    RT_ASSERT((((rt_ubase_t)rmem) & (RT_ALIGN_SIZE - 1)) == 0);
    RT_ASSERT((rt_uint8_t *)rmem >= (rt_uint8_t *)buddy->heap_ptr);
    RT_ASSERT((rt_uint8_t *)rmem < (rt_uint8_t *)buddy->heap_end);

    mem = (struct rt_buddy_small_mem_item *)((rt_uint8_t *)rmem - BUDDY_SIZEOF_STRUCT_MEM);

    ptr = (rt_ubase_t)((rt_uint8_t *)mem - buddy->heap_ptr);
    size = mem->next - ptr - BUDDY_SIZEOF_STRUCT_MEM;
    if (size == newsize)
    {
        return rmem;
    }

    if (newsize + BUDDY_SIZEOF_STRUCT_MEM + BUDDY_MIN_SIZE < size)
    {
        buddy->parent.used -= (size - newsize);

        ptr2 = ptr + BUDDY_SIZEOF_STRUCT_MEM + newsize;
        mem2 = (struct rt_buddy_small_mem_item *)&buddy->heap_ptr[ptr2];
        mem2->pool_ptr = BUDDY_MEM_FREED(buddy);
        mem2->next = mem->next;
        mem2->prev = ptr;
        mem->next = ptr2;
        if (mem2->next != buddy->mem_size_aligned + BUDDY_SIZEOF_STRUCT_MEM)
        {
            ((struct rt_buddy_small_mem_item *)&buddy->heap_ptr[mem2->next])->prev = ptr2;
        }

        if (mem2 < buddy->lfree)
        {
            buddy->lfree = mem2;
        }

        buddy_plug_holes(buddy, mem2);

        return rmem;
    }

    nmem = rt_buddy_alloc(m, newsize);
    if (nmem != RT_NULL)
    {
        rt_memcpy(nmem, rmem, size < newsize ? size : newsize);
        rt_buddy_free(m, rmem);
    }

    return nmem;
}
RTM_EXPORT(rt_buddy_realloc);

void rt_buddy_free(rt_buddy_t buddy_handle, void *rmem)
{
    struct rt_buddy_small_mem_item *mem;
    struct rt_buddy *buddy;

    if (rmem == RT_NULL)
        return;

    RT_ASSERT((((rt_ubase_t)rmem) & (RT_ALIGN_SIZE - 1)) == 0);

    mem = (struct rt_buddy_small_mem_item *)((rt_uint8_t *)rmem - BUDDY_SIZEOF_STRUCT_MEM);
    if (buddy_handle != RT_NULL) {
        buddy = (struct rt_buddy *)buddy_handle;
    } else {
        buddy = BUDDY_MEM_POOL(mem);
    }
    RT_ASSERT(buddy != RT_NULL);
    RT_ASSERT(BUDDY_MEM_ISUSED(mem));
    RT_ASSERT(rt_object_get_type(&buddy->parent.parent) == RT_Object_Class_Memory);
    RT_ASSERT(rt_object_is_systemobject(&buddy->parent.parent));
    RT_ASSERT((rt_uint8_t *)rmem >= (rt_uint8_t *)buddy->heap_ptr &&
              (rt_uint8_t *)rmem < (rt_uint8_t *)buddy->heap_end);

    mem->pool_ptr = BUDDY_MEM_FREED(buddy);

    if (mem < buddy->lfree)
    {
        buddy->lfree = mem;
    }

    buddy->parent.used -= (mem->next - ((rt_ubase_t)((rt_uint8_t *)mem - buddy->heap_ptr)));

    buddy_plug_holes(buddy, mem);
}
RTM_EXPORT(rt_buddy_free);

void rt_buddy_info(rt_buddy_t buddy_handle, rt_size_t *total, rt_size_t *used, rt_size_t *max_used)
{
    struct rt_buddy *buddy = (struct rt_buddy *)buddy_handle;
    
    if (buddy == RT_NULL) {
        if (total) *total = 0;
        if (used) *used = 0;
        if (max_used) *max_used = 0;
        return;
    }
    
    if (total) *total = buddy->parent.total;
    if (used) *used = buddy->parent.used;
    if (max_used) *max_used = buddy->parent.max;
}
RTM_EXPORT(rt_buddy_info);
#endif

#endif
