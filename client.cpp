#include "client.h"
#include <QQmlContext>

Client::Client(QObject *parent, QQmlApplicationEngine *engine) :
    QObject(parent)
{
    this->engine = engine;

    this->connection = new Connection(this);

    connect(this->connection, SIGNAL(newQMLCodeRecieved(QString)), this, SLOT(newQMLCodeRecieved(QString)));
}

void Client::newQMLCodeRecieved(const QString &QMLCode)
{
    this->setUiData(QMLCode);
}

void Client::setUiData(const QString &data)
{
    qDebug() << "UI Data changed!";
    m_ui_data = data;
    emit uiDataChanged();
}

QString Client::uiData() const
{
    return m_ui_data;
}

void Client::connectToAddress(const QString &address, const QString &port)
{
    if(this->connection->isOpen())
        this->connection->close();

    this->connection->connectToHost(address, port.toInt());
}
