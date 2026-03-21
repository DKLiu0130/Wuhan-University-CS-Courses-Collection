/********************************************************************************
** Form generated from reading UI file 'dialog6.ui'
**
** Created by: Qt User Interface Compiler version 6.5.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DIALOG6_H
#define UI_DIALOG6_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_Dialog6
{
public:
    QLabel *label;
    QPushButton *pushButton_back;

    void setupUi(QDialog *Dialog6)
    {
        if (Dialog6->objectName().isEmpty())
            Dialog6->setObjectName("Dialog6");
        Dialog6->resize(428, 362);
        label = new QLabel(Dialog6);
        label->setObjectName("label");
        label->setGeometry(QRect(160, 20, 161, 61));
        QFont font;
        font.setFamilies({QString::fromUtf8("\351\273\221\344\275\223")});
        font.setPointSize(28);
        label->setFont(font);
        pushButton_back = new QPushButton(Dialog6);
        pushButton_back->setObjectName("pushButton_back");
        pushButton_back->setGeometry(QRect(10, 10, 75, 23));

        retranslateUi(Dialog6);

        QMetaObject::connectSlotsByName(Dialog6);
    } // setupUi

    void retranslateUi(QDialog *Dialog6)
    {
        Dialog6->setWindowTitle(QCoreApplication::translate("Dialog6", "Dialog", nullptr));
        label->setText(QCoreApplication::translate("Dialog6", "\344\275\277\347\224\250\350\257\264\346\230\216", nullptr));
        pushButton_back->setText(QCoreApplication::translate("Dialog6", "<\350\277\224\345\233\236", nullptr));
    } // retranslateUi

};

namespace Ui {
    class Dialog6: public Ui_Dialog6 {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DIALOG6_H
