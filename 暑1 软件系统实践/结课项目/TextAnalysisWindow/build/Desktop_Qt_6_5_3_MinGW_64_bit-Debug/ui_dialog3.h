/********************************************************************************
** Form generated from reading UI file 'dialog3.ui'
**
** Created by: Qt User Interface Compiler version 6.5.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DIALOG3_H
#define UI_DIALOG3_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTextEdit>

QT_BEGIN_NAMESPACE

class Ui_Dialog3
{
public:
    QPushButton *pushButton_back;
    QLabel *label;
    QTextEdit *program_introduction;

    void setupUi(QDialog *Dialog3)
    {
        if (Dialog3->objectName().isEmpty())
            Dialog3->setObjectName("Dialog3");
        Dialog3->resize(550, 417);
        pushButton_back = new QPushButton(Dialog3);
        pushButton_back->setObjectName("pushButton_back");
        pushButton_back->setGeometry(QRect(10, 10, 75, 23));
        label = new QLabel(Dialog3);
        label->setObjectName("label");
        label->setGeometry(QRect(160, 20, 191, 81));
        QFont font;
        font.setFamilies({QString::fromUtf8("\351\273\221\344\275\223")});
        font.setPointSize(36);
        label->setFont(font);
        program_introduction = new QTextEdit(Dialog3);
        program_introduction->setObjectName("program_introduction");
        program_introduction->setGeometry(QRect(40, 130, 481, 251));

        retranslateUi(Dialog3);

        QMetaObject::connectSlotsByName(Dialog3);
    } // setupUi

    void retranslateUi(QDialog *Dialog3)
    {
        Dialog3->setWindowTitle(QCoreApplication::translate("Dialog3", "Dialog", nullptr));
        pushButton_back->setText(QCoreApplication::translate("Dialog3", "<\350\277\224\345\233\236", nullptr));
        label->setText(QCoreApplication::translate("Dialog3", "\347\250\213\345\272\217\347\256\200\344\273\213", nullptr));
    } // retranslateUi

};

namespace Ui {
    class Dialog3: public Ui_Dialog3 {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DIALOG3_H
