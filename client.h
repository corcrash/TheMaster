#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QtQml/QQmlApplicationEngine>
#include "connection.h"

class Client : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ui_data READ uiData WRITE setUiData NOTIFY uiDataChanged)

private:
    Connection *connection;
    QQmlApplicationEngine *engine;
    QString m_ui_data;


public:
    explicit Client(QObject *parent = 0, QQmlApplicationEngine *engine = 0);
    void setUiData(const QString &data);
    QString uiData() const;
    Q_INVOKABLE void connectToAddress(const QString &address, const QString &port);

signals:
    void uiDataChanged();

public slots:
    void newQMLCodeRecieved(const QString &QMLCode);

};

#endif // CLIENT_H
