#include "client.h"
#include <QQmlContext>
#include <QFile>

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

void Client::emitSignal(const QString &signal_descriptor, const QString &data)
{
    this->connection->sendEventMessage(signal_descriptor, data);
}

void Client::writeConnections(const QString &data)
{
    QFile file("connections.json");
    file.open(QIODevice::WriteOnly);
    file.write(data.toUtf8());
    file.close();
}

QString Client::readConnections()
{
    QFile file("connections.json");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    file.close();

    return QString::fromUtf8(data);
}
