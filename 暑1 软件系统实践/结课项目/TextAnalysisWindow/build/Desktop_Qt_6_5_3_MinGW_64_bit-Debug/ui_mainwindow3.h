/********************************************************************************
** Form generated from reading UI file 'mainwindow3.ui'
**
** Created by: Qt User Interface Compiler version 6.5.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW3_H
#define UI_MAINWINDOW3_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow3
{
public:
    QWidget *centralwidget;
    QHBoxLayout *horizontalLayout_5;
    QHBoxLayout *horizontalLayout_3;
    QVBoxLayout *verticalLayout_2;
    QPushButton *pushButton_back;
    QSpacerItem *verticalSpacer_4;
    QPushButton *pushButton_nomal;
    QSpacerItem *verticalSpacer_5;
    QPushButton *pushButton_AI;
    QSpacerItem *verticalSpacer_6;
    QPushButton *pushButton_help;
    QSpacerItem *verticalSpacer_7;
    QVBoxLayout *verticalLayout_4;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout_4;
    QSpacerItem *horizontalSpacer_6;
    QLabel *label_3;
    QSpacerItem *horizontalSpacer_7;
    QLabel *label_2;
    QSpacerItem *horizontalSpacer_8;
    QHBoxLayout *horizontalLayout;
    QPlainTextEdit *plainTextEdit_A;
    QSpacerItem *horizontalSpacer_3;
    QPlainTextEdit *plainTextEdit_B;
    QHBoxLayout *horizontalLayout_2;
    QSpacerItem *horizontalSpacer_4;
    QPushButton *pushButton_chooseA;
    QSpacerItem *horizontalSpacer_2;
    QPushButton *pushButton_chooseB;
    QSpacerItem *horizontalSpacer_5;
    QVBoxLayout *verticalLayout_3;
    QLabel *label;
    QTextBrowser *textBrowser;
    QVBoxLayout *verticalLayout_6;
    QSpacerItem *verticalSpacer;
    QPushButton *pushButton_begin;
    QSpacerItem *verticalSpacer_2;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow3)
    {
        if (MainWindow3->objectName().isEmpty())
            MainWindow3->setObjectName("MainWindow3");
        MainWindow3->resize(992, 645);
        centralwidget = new QWidget(MainWindow3);
        centralwidget->setObjectName("centralwidget");
        horizontalLayout_5 = new QHBoxLayout(centralwidget);
        horizontalLayout_5->setObjectName("horizontalLayout_5");
        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setObjectName("horizontalLayout_3");
        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setObjectName("verticalLayout_2");
        pushButton_back = new QPushButton(centralwidget);
        pushButton_back->setObjectName("pushButton_back");

        verticalLayout_2->addWidget(pushButton_back);

        verticalSpacer_4 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_4);

        pushButton_nomal = new QPushButton(centralwidget);
        pushButton_nomal->setObjectName("pushButton_nomal");
        pushButton_nomal->setStyleSheet(QString::fromUtf8("QPushButton{\n"
"border:1px solid white;   /*\350\276\271\346\241\206\347\232\204\347\262\227\347\273\206\357\274\214\351\242\234\350\211\262*/\n"
"border-radius:15px;    /*\350\256\276\347\275\256\345\234\206\350\247\222\345\215\212\345\276\204 */\n"
"padding:2px 4px;  /*QFrame\350\276\271\346\241\206\344\270\216\345\206\205\351\203\250\345\205\266\345\256\203\351\203\250\344\273\266\347\232\204\350\267\235\347\246\273*/\n"
"background-color: white;	/*\350\203\214\346\231\257\351\242\234\350\211\262*/\n"
"color: black;		/*\345\255\227\344\275\223\351\242\234\350\211\262*/\n"
"min-width:100px;	/*\350\256\276\347\275\256\346\234\200\345\260\217\345\256\275\345\272\246*/\n"
"min-height:50px;	/*\350\256\276\347\275\256\346\234\200\345\260\217\351\253\230\345\272\246*/\n"
"font:bold 18px;		/*\350\256\276\347\275\256\346\214\211\351\222\256\346\226\207\345\255\227\345\222\214\345\244\247\345\260\217*/\n"
"}"));

        verticalLayout_2->addWidget(pushButton_nomal);

        verticalSpacer_5 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_5);

        pushButton_AI = new QPushButton(centralwidget);
        pushButton_AI->setObjectName("pushButton_AI");
        pushButton_AI->setStyleSheet(QString::fromUtf8("QPushButton{\n"
"border:1px solid white;   /*\350\276\271\346\241\206\347\232\204\347\262\227\347\273\206\357\274\214\351\242\234\350\211\262*/\n"
"border-radius:15px;    /*\350\256\276\347\275\256\345\234\206\350\247\222\345\215\212\345\276\204 */\n"
"padding:2px 4px;  /*QFrame\350\276\271\346\241\206\344\270\216\345\206\205\351\203\250\345\205\266\345\256\203\351\203\250\344\273\266\347\232\204\350\267\235\347\246\273*/\n"
"background-color: red;	/*\350\203\214\346\231\257\351\242\234\350\211\262*/\n"
"color:white;		/*\345\255\227\344\275\223\351\242\234\350\211\262*/\n"
"min-width:100px;	/*\350\256\276\347\275\256\346\234\200\345\260\217\345\256\275\345\272\246*/\n"
"min-height:50px;	/*\350\256\276\347\275\256\346\234\200\345\260\217\351\253\230\345\272\246*/\n"
"font:bold 18px;		/*\350\256\276\347\275\256\346\214\211\351\222\256\346\226\207\345\255\227\345\222\214\345\244\247\345\260\217*/\n"
"}"));

        verticalLayout_2->addWidget(pushButton_AI);

        verticalSpacer_6 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_6);

        pushButton_help = new QPushButton(centralwidget);
        pushButton_help->setObjectName("pushButton_help");
        QFont font;
        font.setFamilies({QString::fromUtf8("\351\273\221\344\275\223")});
        font.setPointSize(11);
        pushButton_help->setFont(font);

        verticalLayout_2->addWidget(pushButton_help);

        verticalSpacer_7 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_7);

        verticalLayout_2->setStretch(0, 5);
        verticalLayout_2->setStretch(1, 10);
        verticalLayout_2->setStretch(2, 10);
        verticalLayout_2->setStretch(3, 10);
        verticalLayout_2->setStretch(4, 10);
        verticalLayout_2->setStretch(5, 10);
        verticalLayout_2->setStretch(6, 5);
        verticalLayout_2->setStretch(7, 40);

        horizontalLayout_3->addLayout(verticalLayout_2);

        verticalLayout_4 = new QVBoxLayout();
        verticalLayout_4->setObjectName("verticalLayout_4");
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName("verticalLayout");
        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setObjectName("horizontalLayout_4");
        horizontalSpacer_6 = new QSpacerItem(98, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_6);

        label_3 = new QLabel(centralwidget);
        label_3->setObjectName("label_3");
        QFont font1;
        font1.setFamilies({QString::fromUtf8("\345\276\256\350\275\257\351\233\205\351\273\221")});
        font1.setPointSize(12);
        label_3->setFont(font1);

        horizontalLayout_4->addWidget(label_3);

        horizontalSpacer_7 = new QSpacerItem(228, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_7);

        label_2 = new QLabel(centralwidget);
        label_2->setObjectName("label_2");
        label_2->setFont(font1);

        horizontalLayout_4->addWidget(label_2);

        horizontalSpacer_8 = new QSpacerItem(98, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_8);


        verticalLayout->addLayout(horizontalLayout_4);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName("horizontalLayout");
        plainTextEdit_A = new QPlainTextEdit(centralwidget);
        plainTextEdit_A->setObjectName("plainTextEdit_A");
        plainTextEdit_A->setMinimumSize(QSize(0, 150));

        horizontalLayout->addWidget(plainTextEdit_A);

        horizontalSpacer_3 = new QSpacerItem(18, 20, QSizePolicy::Preferred, QSizePolicy::Minimum);

        horizontalLayout->addItem(horizontalSpacer_3);

        plainTextEdit_B = new QPlainTextEdit(centralwidget);
        plainTextEdit_B->setObjectName("plainTextEdit_B");
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(plainTextEdit_B->sizePolicy().hasHeightForWidth());
        plainTextEdit_B->setSizePolicy(sizePolicy);
        plainTextEdit_B->setMinimumSize(QSize(200, 150));
        plainTextEdit_B->setMaximumSize(QSize(16777215, 600));

        horizontalLayout->addWidget(plainTextEdit_B);


        verticalLayout->addLayout(horizontalLayout);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName("horizontalLayout_2");
        horizontalSpacer_4 = new QSpacerItem(78, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_4);

        pushButton_chooseA = new QPushButton(centralwidget);
        pushButton_chooseA->setObjectName("pushButton_chooseA");

        horizontalLayout_2->addWidget(pushButton_chooseA);

        horizontalSpacer_2 = new QSpacerItem(188, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_2);

        pushButton_chooseB = new QPushButton(centralwidget);
        pushButton_chooseB->setObjectName("pushButton_chooseB");

        horizontalLayout_2->addWidget(pushButton_chooseB);

        horizontalSpacer_5 = new QSpacerItem(78, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_5);


        verticalLayout->addLayout(horizontalLayout_2);


        verticalLayout_4->addLayout(verticalLayout);

        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setObjectName("verticalLayout_3");
        label = new QLabel(centralwidget);
        label->setObjectName("label");
        QFont font2;
        font2.setPointSize(12);
        label->setFont(font2);

        verticalLayout_3->addWidget(label);

        textBrowser = new QTextBrowser(centralwidget);
        textBrowser->setObjectName("textBrowser");

        verticalLayout_3->addWidget(textBrowser);


        verticalLayout_4->addLayout(verticalLayout_3);

        verticalLayout_4->setStretch(0, 60);
        verticalLayout_4->setStretch(1, 40);

        horizontalLayout_3->addLayout(verticalLayout_4);

        verticalLayout_6 = new QVBoxLayout();
        verticalLayout_6->setObjectName("verticalLayout_6");
        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_6->addItem(verticalSpacer);

        pushButton_begin = new QPushButton(centralwidget);
        pushButton_begin->setObjectName("pushButton_begin");
        QSizePolicy sizePolicy1(QSizePolicy::Fixed, QSizePolicy::Minimum);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(pushButton_begin->sizePolicy().hasHeightForWidth());
        pushButton_begin->setSizePolicy(sizePolicy1);
        pushButton_begin->setMinimumSize(QSize(110, 56));
        QFont font3;
        font3.setFamilies({QString::fromUtf8("\351\273\221\344\275\223")});
        font3.setBold(true);
        font3.setItalic(false);
        font3.setUnderline(true);
        pushButton_begin->setFont(font3);
        pushButton_begin->setStyleSheet(QString::fromUtf8("\n"
"QPushButton{\n"
"border:1px solid white;   /*\350\276\271\346\241\206\347\232\204\347\262\227\347\273\206\357\274\214\351\242\234\350\211\262*/\n"
"border-radius:15px;    /*\350\256\276\347\275\256\345\234\206\350\247\222\345\215\212\345\276\204 */\n"
"padding:2px 4px;  /*QFrame\350\276\271\346\241\206\344\270\216\345\206\205\351\203\250\345\205\266\345\256\203\351\203\250\344\273\266\347\232\204\350\267\235\347\246\273*/\n"
"background-color: rgb(70, 129, 255);	/*\350\203\214\346\231\257\351\242\234\350\211\262*/\n"
"color:white;		/*\345\255\227\344\275\223\351\242\234\350\211\262*/\n"
"min-width:100px;	/*\350\256\276\347\275\256\346\234\200\345\260\217\345\256\275\345\272\246*/\n"
"min-height:50px;	/*\350\256\276\347\275\256\346\234\200\345\260\217\351\253\230\345\272\246*/\n"
"font:bold 18px;		/*\350\256\276\347\275\256\346\214\211\351\222\256\346\226\207\345\255\227\345\222\214\345\244\247\345\260\217*/\n"
"}"));
        pushButton_begin->setCheckable(false);

        verticalLayout_6->addWidget(pushButton_begin);

        verticalSpacer_2 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_6->addItem(verticalSpacer_2);

        verticalLayout_6->setStretch(0, 30);
        verticalLayout_6->setStretch(1, 10);
        verticalLayout_6->setStretch(2, 60);

        horizontalLayout_3->addLayout(verticalLayout_6);


        horizontalLayout_5->addLayout(horizontalLayout_3);

        MainWindow3->setCentralWidget(centralwidget);
        statusbar = new QStatusBar(MainWindow3);
        statusbar->setObjectName("statusbar");
        MainWindow3->setStatusBar(statusbar);

        retranslateUi(MainWindow3);

        QMetaObject::connectSlotsByName(MainWindow3);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow3)
    {
        MainWindow3->setWindowTitle(QCoreApplication::translate("MainWindow3", "MainWindow", nullptr));
        pushButton_back->setText(QCoreApplication::translate("MainWindow3", "<\350\277\224\345\233\236", nullptr));
        pushButton_nomal->setText(QCoreApplication::translate("MainWindow3", "\346\231\256\351\200\232\345\210\206\346\236\220", nullptr));
        pushButton_AI->setText(QCoreApplication::translate("MainWindow3", "AI\345\210\206\346\236\220", nullptr));
        pushButton_help->setText(QCoreApplication::translate("MainWindow3", "\345\270\256\345\212\251", nullptr));
        label_3->setText(QCoreApplication::translate("MainWindow3", "\346\226\207\346\234\254A", nullptr));
        label_2->setText(QCoreApplication::translate("MainWindow3", "\346\226\207\346\234\254B", nullptr));
        plainTextEdit_B->setPlainText(QString());
        pushButton_chooseA->setText(QCoreApplication::translate("MainWindow3", "\351\200\211\346\213\251\346\226\207\344\273\266", nullptr));
        pushButton_chooseB->setText(QCoreApplication::translate("MainWindow3", "\351\200\211\346\213\251\346\226\207\344\273\266", nullptr));
        label->setText(QCoreApplication::translate("MainWindow3", "\345\210\206\346\236\220\347\273\223\346\236\234", nullptr));
        pushButton_begin->setText(QCoreApplication::translate("MainWindow3", "\345\274\200\345\247\213\345\210\206\346\236\220", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow3: public Ui_MainWindow3 {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW3_H
