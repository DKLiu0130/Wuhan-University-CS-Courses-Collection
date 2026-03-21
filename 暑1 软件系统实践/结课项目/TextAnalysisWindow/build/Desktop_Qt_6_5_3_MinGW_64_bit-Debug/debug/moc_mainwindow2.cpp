/****************************************************************************
** Meta object code from reading C++ file 'mainwindow2.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.5.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../../../../Qt/Project/TextAnalysisWindow/mainwindow2.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#if __has_include(<QtCore/qtmochelpers.h>)
#include <QtCore/qtmochelpers.h>
#else
QT_BEGIN_MOC_NAMESPACE
#endif


#include <memory>

#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow2.h' doesn't include <QObject>."
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
struct qt_meta_stringdata_CLASSMainWindow2ENDCLASS_t {};
static constexpr auto qt_meta_stringdata_CLASSMainWindow2ENDCLASS = QtMocHelpers::stringData(
    "MainWindow2",
    "goback",
    "",
    "on_pushButton_clicked",
    "on_pushButton_help_clicked",
    "on_pushButton_AI_clicked",
    "on_pushButton_chooseA_clicked",
    "on_pushButton_chooseB_clicked",
    "on_comboBox_activated",
    "index",
    "on_pushButton_begin_clicked",
    "onSimilarityCalculated",
    "similarity"
);
#else  // !QT_MOC_HAS_STRING_DATA
struct qt_meta_stringdata_CLASSMainWindow2ENDCLASS_t {
    uint offsetsAndSizes[26];
    char stringdata0[12];
    char stringdata1[7];
    char stringdata2[1];
    char stringdata3[22];
    char stringdata4[27];
    char stringdata5[25];
    char stringdata6[30];
    char stringdata7[30];
    char stringdata8[22];
    char stringdata9[6];
    char stringdata10[28];
    char stringdata11[23];
    char stringdata12[11];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_CLASSMainWindow2ENDCLASS_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_CLASSMainWindow2ENDCLASS_t qt_meta_stringdata_CLASSMainWindow2ENDCLASS = {
    {
        QT_MOC_LITERAL(0, 11),  // "MainWindow2"
        QT_MOC_LITERAL(12, 6),  // "goback"
        QT_MOC_LITERAL(19, 0),  // ""
        QT_MOC_LITERAL(20, 21),  // "on_pushButton_clicked"
        QT_MOC_LITERAL(42, 26),  // "on_pushButton_help_clicked"
        QT_MOC_LITERAL(69, 24),  // "on_pushButton_AI_clicked"
        QT_MOC_LITERAL(94, 29),  // "on_pushButton_chooseA_clicked"
        QT_MOC_LITERAL(124, 29),  // "on_pushButton_chooseB_clicked"
        QT_MOC_LITERAL(154, 21),  // "on_comboBox_activated"
        QT_MOC_LITERAL(176, 5),  // "index"
        QT_MOC_LITERAL(182, 27),  // "on_pushButton_begin_clicked"
        QT_MOC_LITERAL(210, 22),  // "onSimilarityCalculated"
        QT_MOC_LITERAL(233, 10)   // "similarity"
    },
    "MainWindow2",
    "goback",
    "",
    "on_pushButton_clicked",
    "on_pushButton_help_clicked",
    "on_pushButton_AI_clicked",
    "on_pushButton_chooseA_clicked",
    "on_pushButton_chooseB_clicked",
    "on_comboBox_activated",
    "index",
    "on_pushButton_begin_clicked",
    "onSimilarityCalculated",
    "similarity"
};
#undef QT_MOC_LITERAL
#endif // !QT_MOC_HAS_STRING_DATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSMainWindow2ENDCLASS[] = {

 // content:
      11,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   68,    2, 0x06,    1 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
       3,    0,   69,    2, 0x08,    2 /* Private */,
       4,    0,   70,    2, 0x08,    3 /* Private */,
       5,    0,   71,    2, 0x08,    4 /* Private */,
       6,    0,   72,    2, 0x08,    5 /* Private */,
       7,    0,   73,    2, 0x08,    6 /* Private */,
       8,    1,   74,    2, 0x08,    7 /* Private */,
      10,    0,   77,    2, 0x08,    9 /* Private */,
      11,    1,   78,    2, 0x08,   10 /* Private */,

 // signals: parameters
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,    9,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Double,   12,

       0        // eod
};

Q_CONSTINIT const QMetaObject MainWindow2::staticMetaObject = { {
    QMetaObject::SuperData::link<QMainWindow::staticMetaObject>(),
    qt_meta_stringdata_CLASSMainWindow2ENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSMainWindow2ENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSMainWindow2ENDCLASS_t,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<MainWindow2, std::true_type>,
        // method 'goback'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_help_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_AI_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_chooseA_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_pushButton_chooseB_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'on_comboBox_activated'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'on_pushButton_begin_clicked'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'onSimilarityCalculated'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<double, std::false_type>
    >,
    nullptr
} };

void MainWindow2::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<MainWindow2 *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->goback(); break;
        case 1: _t->on_pushButton_clicked(); break;
        case 2: _t->on_pushButton_help_clicked(); break;
        case 3: _t->on_pushButton_AI_clicked(); break;
        case 4: _t->on_pushButton_chooseA_clicked(); break;
        case 5: _t->on_pushButton_chooseB_clicked(); break;
        case 6: _t->on_comboBox_activated((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 7: _t->on_pushButton_begin_clicked(); break;
        case 8: _t->onSimilarityCalculated((*reinterpret_cast< std::add_pointer_t<double>>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (MainWindow2::*)();
            if (_t _q_method = &MainWindow2::goback; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject *MainWindow2::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MainWindow2::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSMainWindow2ENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow2::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void MainWindow2::goback()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
