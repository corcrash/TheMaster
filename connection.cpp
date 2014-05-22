#include "connection.h"

#include <QJsonDocument>
#include <QJsonObject>

Connection::Connection(QObject *parent) :
    QTcpSocket(parent)
{
    connect(this, SIGNAL(readyRead()), this, SLOT(processReadyRead()));
    connect(this, SIGNAL(connected()), this, SLOT(processConnected()));
    connect(this, SIGNAL(disconnected()), this, SLOT(deleteLater()));
}

bool Connection::sendEventMessage(const QString &eventMessage, const QVariant &data)
{
    if(eventMessage.isEmpty())
        return false;

    QByteArray buffer = QString("{ \"type\": \"eventMessage\", \"identifier\": \"" + eventMessage + "\", \"data\": \"" + data.toString() + "\" }").toUtf8();

    if(this->write(buffer) == buffer.size())
        return true;

    return false;
}

bool Connection::sendQMLRequest()
{
    QString request = "{ \"type\" : \"QMLRequest\" }";

    if(this->write(request.toUtf8()) == request.toUtf8().size())
        return true;

    return false;
}

int Connection::readDataIntoBuffer(int maxSize)
{
    if(maxSize > MAX_BUFFER_SIZE)
        return 0;

    int bufferSizeBeforeRead = this->buffer.size();
    if(bufferSizeBeforeRead >= MAX_BUFFER_SIZE)
    {
        this->abort();
        return 0;
    }

    while(this->bytesAvailable() && this->buffer.size() < maxSize)
    {
        this->buffer.append(this->read(1));
    }

    return this->buffer.size() - bufferSizeBeforeRead;

}

void Connection::processReadyRead()
{
    if(this->readDataIntoBuffer() <= 0)
        return;

    QJsonDocument tempDocument = QJsonDocument::fromJson(this->buffer);

    QJsonObject recievedData = tempDocument.object();

    if(recievedData["type"].toString() == "QMLCode")
    {
        emit newQMLCodeRecieved(recievedData["data"].toString());
        this->buffer.clear();
        return;
    }
}

void Connection::processConnected()
{
    this->sendQMLRequest();
}
