/****************************************************************************
** Meta object code from reading C++ file 'mainwindow3.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.5.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../../../../Qt/Project/TextAnalysisWindow/mainwindow3.h"
#include <QtCore/qmetatype.h>

#if __has_include(<QtCore/qtmochelpers.h>)
#include <QtCore/qtmochelpers.h>
#else
QT_BEGIN_MOC_NAMESPACE
#endif


#include <memory>

#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow3.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.5.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {

#ifdef QT_MOC_HAS_STRINGDATA
struct qt_meta_stringdata_CLASSMainWindow3ENDCLASS_t {};
static constexpr auto qt_meta_stringdata_CLASSMainWindow3ENDCLASS = QtMocHelpers::stringData(
    "MainWindow3",
    "goback",
    "",
    "on_pushButton_nomal_clicked",
    "on_pushButton_back_clicked",
    "on_pushButton_chooseA_clicked",
    "on_pushButton_chooseB_clicked",
    "on_pushButton_help_clicked",
    "on_pushButton_begin_clicked"
);
#else  // !QT_MOC_HAS_STRING_DATA
struct qt_meta_stringdata_CLASSMainWindow3ENDCLASS_t {
    uint offsetsAndSizes[18];
    char stringdata0[12];
    char stringdata1[7];
    char stringdata2[1];
    char stringdata3[28];
    char stringdata4[27];
    char stringdata5[30];
    char stringdata6[30];
    char stringdata7[27];
    char stringdata8[28];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_CLASSMainWindow3ENDCLASS_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_CLASSMainWindow3ENDCLASS_t qt_meta_stringdata_CLASSMainWindow3ENDCLASS = {
    {
        QT_MOC_LITERAL(0, 11),  // "MainWindow3"
        QT_MOC_LITERAL(12, 6),  // "goback"
        QT_MOC_LITERAL(19, 0),  // ""
        QT_MOC_LITERAL(20, 27),  // "on_pushButton_nomal_clicked"
        QT_MOC_LITERAL(48, 26),  // "on_pushButton_back_clicked"
        QT_MOC_LITERAL(75, 29),  // "on_pushButton_chooseA_clicked"
        QT_MOC_LITERAL(105, 29),  // "on_pushButton_chooseB_clicked"
        QT_MOC_LITERAL(135, 26),  // "on_pushButton_help_clicked"
        QT_MOC_LITERAL(162, 27)   // "on_pushButton_begin_clicked"
    },
    "MainWindow3",
    "goback",
    "",
    "on_pushButton_nomal_clicked",
    "on_pushButton_back_clicked",
    "on_pushButton_chooseA_clicked",
    "on_pushButton_chooseB_clicked",
    "on_pushButton_help_clicked",
    "on_pushButton_begin_clicked"
};
#undef QT_MOC_LITERAL
#endif // !QT_MOC_HAS_STRING_DATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSMainWindow3ENDCLASS[] = {

 // content:
      11,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   56,    2, 0x06,    1 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
       3,    0,   57,    2, 0x08,    2 /* Private */,
       4,    0,   58,    2, 0x08,    3 /* Private */,
       5,    0,   59,    2, 0x08,    4 /* Private */,
       6,    0,   60,    2, 0x08,    5 /* Private */,
       7,    0,   61,    2, 0x08,    6 /* Private */,
       8,    0,   62,    2, 0x08,    7 /* Private */,

 // signals: parameters
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

Q_CONSTINIT const QMetaObject MainWindow3::staticMetaObject = { {
    QMetaObject::SuperData::link<QMainWindow::staticMetaObject>(),
    qt_meta_stringdata_CLASSMainWindow3ENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSMainWindow3ENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSMainWindow3ENDCLASS_t,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<MainWindow3, std::true_type>,
        // method 'goback'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_nomal_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_back_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_chooseA_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_chooseB_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_help_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_begin_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>
    >,
    nullptr
} };

void MainWindow3::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<MainWindow3 *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->goback(); break;
        case 1: _t->on_pushButton_nomal_clicked(); break;
        case 2: _t->on_pushButton_back_clicked(); break;
        case 3: _t->on_pushButton_chooseA_clicked(); break;
        case 4: _t->on_pushButton_chooseB_clicked(); break;
        case 5: _t->on_pushButton_help_clicked(); break;
        case 6: _t->on_pushButton_begin_clicked(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (MainWindow3::*)();
            if (_t _q_method = &MainWindow3::goback; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
    }
    (void)_a;
}

const QMetaObject *MainWindow3::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MainWindow3::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSMainWindow3ENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow3::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 7;
    }
    return _id;
}

// SIGNAL 0
void MainWindow3::goback()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
