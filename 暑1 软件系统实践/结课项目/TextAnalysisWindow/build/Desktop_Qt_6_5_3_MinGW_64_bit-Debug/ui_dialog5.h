/********************************************************************************
** Form generated from reading UI file 'dialog5.ui'
**
** Created by: Qt User Interface Compiler version 6.5.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DIALOG5_H
#define UI_DIALOG5_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_Dialog5
{
public:
    QPushButton *pushButton;
    QLabel *label;

    void setupUi(QDialog *Dialog5)
    {
        if (Dialog5->objectName().isEmpty())
            Dialog5->setObjectName("Dialog5");
        Dialog5->resize(500, 430);
        pushButton = new QPushButton(Dialog5);
        pushButton->setObjectName("pushButton");
        pushButton->setGeometry(QRect(10, 10, 75, 23));
        label = new QLabel(Dialog5);
        label->setObjectName("label");
        label->setGeometry(QRect(160, 30, 161, 61));
        QFont font;
        font.setFamilies({QString::fromUtf8("\351\273\221\344\275\223")});
        font.setPointSize(28);
        label->setFont(font);

        retranslateUi(Dialog5);

        QMetaObject::connectSlotsByName(Dialog5);
    } // setupUi

    void retranslateUi(QDialog *Dialog5)
    {
        Dialog5->setWindowTitle(QCoreApplication::translate("Dialog5", "Dialog", nullptr));
        pushButton->setText(QCoreApplication::translate("Dialog5", "<\350\277\224\345\233\236", nullptr));
        label->setText(QCoreApplication::translate("Dialog5", "\344\275\277\347\224\250\350\257\264\346\230\216", nullptr));
    } // retranslateUi

};

namespace Ui {
    class Dialog5: public Ui_Dialog5 {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DIALOG5_H
