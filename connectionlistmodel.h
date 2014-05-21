#ifndef CONNECTIONLISTMODEL_H
#define CONNECTIONLISTMODEL_H

#include <QAbstractItemModel>

class ConnectionListModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit ConnectionListModel(QObject *parent = 0);

signals:

public slots:

};

#endif // CONNECTIONLISTMODEL_H
