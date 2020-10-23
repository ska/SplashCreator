#ifndef IMAGEMANAGER_H
#define IMAGEMANAGER_H

#include <QObject>
#include <QImage>
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QDir>
#include <QCryptographicHash>

// Taked from Manage Target
#define RGB16(red, green, blue) ( (((red >> 3) << 11) & 0xF800)| (((green >> 2) << 5) & 0x07E0) | ((blue >> 3) & 0x001F))

#define OUTPUT_PATH "OutImgs/"
#define IMGBIN_FNAME OUTPUT_PATH "splashimage.bin"
#define RSZBMP_FNAME OUTPUT_PATH "resized24.bmp"

typedef struct _splashHeader
{
    unsigned long stride;
    unsigned long lcrtl;
    unsigned long mainImageSize;
    unsigned long noOfAnimationFrames;
    unsigned long animStride;
    unsigned long animLCtrl;
    unsigned long animX;
    unsigned long animY;
    unsigned long animSize;
    unsigned long animInterval;
    unsigned long reserved[3];
    unsigned long headerChecksum;
} splashHeader;

class ImageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileName  READ getFileName  WRITE setFileName  NOTIFY fileNameChanged)
    Q_PROPERTY(QString outWidth  READ getOutWidth  WRITE setOutWidth  NOTIFY outWidthChanged)
    Q_PROPERTY(QString outHeight READ getOutHeight WRITE setOutHeight NOTIFY outHeightChanged)

    Q_PROPERTY(QString outAspectRatio WRITE setAspectRatio)

public:
    explicit ImageManager(QObject *parent = nullptr);
    /****************/
    QString getFileName();
    void setFileName(const QString &fileName);
    /****************/
    QString getOutWidth();
    void setOutWidth(const QString &outWidth);
    /****************/
    QString getOutHeight();
    void setOutHeight(const QString &outHeight);
    /****************/
    void setAspectRatio(const QString &outAspectRatio);
    /****************/
    void processImage(const QUrl u);
    quint16 rgb24to16(quint32 rgb);
    QString fileChecksum(const QString &fileName, QCryptographicHash::Algorithm hashAlgorithm);
    /****************/
signals:
    void fileNameChanged();
    void outWidthChanged();
    void outHeightChanged();

private slots:

private:
    QString m_fileName;
    quint16 m_outWidth;
    quint16 m_outHeight;

    Qt::AspectRatioMode m_ARout;
};

#endif // IMAGEMANAGER_H
