/********************************************************************************
** Form generated from reading UI file 'dialog4.ui'
**
** Created by: Qt User Interface Compiler version 6.5.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DIALOG4_H
#define UI_DIALOG4_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTextBrowser>

QT_BEGIN_NAMESPACE

class Ui_Dialog4
{
public:
    QPushButton *pushButton_back;
    QLabel *label;
    QTextBrowser *textBrowser;

    void setupUi(QDialog *Dialog4)
    {
        if (Dialog4->objectName().isEmpty())
            Dialog4->setObjectName("Dialog4");
        Dialog4->resize(500, 392);
        pushButton_back = new QPushButton(Dialog4);
        pushButton_back->setObjectName("pushButton_back");
        pushButton_back->setGeometry(QRect(4, 10, 71, 23));
        label = new QLabel(Dialog4);
        label->setObjectName("label");
        label->setGeometry(QRect(140, 40, 201, 71));
        QFont font;
        font.setFamilies({QString::fromUtf8("\351\273\221\344\275\223")});
        font.setPointSize(36);
        label->setFont(font);
        textBrowser = new QTextBrowser(Dialog4);
        textBrowser->setObjectName("textBrowser");
        textBrowser->setGeometry(QRect(70, 120, 331, 211));
        textBrowser->setStyleSheet(QString::fromUtf8("QTextBrowser {\n"
"    background: transparent;\n"
"    border: none;\n"
"    color: black;\n"
"}\n"
""));

        retranslateUi(Dialog4);

        QMetaObject::connectSlotsByName(Dialog4);
    } // setupUi

    void retranslateUi(QDialog *Dialog4)
    {
        Dialog4->setWindowTitle(QCoreApplication::translate("Dialog4", "Dialog", nullptr));
        pushButton_back->setText(QCoreApplication::translate("Dialog4", "<\350\277\224\345\233\236", nullptr));
        label->setText(QCoreApplication::translate("Dialog4", "\345\274\200\345\217\221\344\272\272\345\221\230", nullptr));
        textBrowser->setHtml(QCoreApplication::translate("Dialog4", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"hr { height: 1px; border-width: 0; }\n"
"li.unchecked::marker { content: \"\\2610\"; }\n"
"li.checked::marker { content: \"\\2612\"; }\n"
"</style></head><body style=\" font-family:'Microsoft YaHei UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:18pt;\">\351\203\221\345\226\206\345\256\207\357\274\232\345\210\222\346\260\264</span></p>\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:18pt;\">\345\210\230\345\256\232\345\235\244\357\274\232fjkdjf</span></p></body></html>", nullptr));
    } // retranslateUi

};

namespace Ui {
    class Dialog4: public Ui_Dialog4 {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DIALOG4_H
