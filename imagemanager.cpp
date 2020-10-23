#include "imagemanager.h"
/*
 * ImageManager::ImageManager
 */
ImageManager::ImageManager(QObject *parent) : QObject(parent)
{
    m_outWidth = 800;
    m_outHeight = 480;
    m_ARout = Qt::KeepAspectRatio;
}
/*
 * ImageManager::rgb24to16
 */
quint16 ImageManager::rgb24to16(quint32 rgb)
{
    quint8 r, g, b;
    r = ((rgb & 0x00ff0000) >> 16);
    g = ((rgb & 0x0000ff00) >> 8 );
    b = ((rgb & 0x000000ff) >> 0 );
    //return ((r & 0b11111000) << 8) | ((g & 0b11111100) << 3) | (b >> 3);
    return RGB16(r, g, b);
}
/*
 * ImageManager::fileChecksum
 */
QString ImageManager::fileChecksum(const QString &fileName, QCryptographicHash::Algorithm hashAlgorithm)
{
    QFile sourceFile(fileName);
    qint64 fileSize = sourceFile.size();
    const qint64 bufferSize = 10240;

    if (sourceFile.open(QIODevice::ReadOnly))
    {
        char buffer[bufferSize];
        int bytesRead;
        int readSize = qMin(fileSize, bufferSize);

        QCryptographicHash hash(hashAlgorithm);
        while (readSize > 0 && (bytesRead = sourceFile.read(buffer, readSize)) > 0)
        {
            fileSize -= bytesRead;
            hash.addData(buffer, bytesRead);
            readSize = qMin(fileSize, bufferSize);
        }

        sourceFile.close();
        return QString(hash.result().toHex());
    }
    return QString();
}
/*
 * ImageManager::processImage
 */
void ImageManager::processImage(const QUrl u)
{
    QString test = u.path();
    QImage myImage(test);   
    splashHeader splHeader;

    QDir dir(OUTPUT_PATH);
    if (!dir.exists())
        dir.mkpath(".");

    //qDebug() << "C++ Original Image Size " << myImage.size();
    //qDebug() << "" << hex <<myImage.pixel(10,10);
    QImage *myImageNew = new QImage(myImage.convertToFormat(QImage::Format_RGB16,Qt::AutoColor));
    *myImageNew = myImageNew->scaled(m_outWidth, m_outHeight, m_ARout);

    myImageNew->save(RSZBMP_FNAME);

    //qDebug() << "C++ Hex24: " << hex << myImageNew->pixel(10,10);
    //qDebug() << "C++ Hex16: " << hex << rgb24to16( myImageNew->pixel(10,10) );

    QByteArray rawData;
    rawData.clear();
    quint16 height = myImageNew->size().height();
    quint16 width = myImageNew->size().width();

    memset(&splHeader, 0, sizeof(splashHeader));
    splHeader.stride = width * 2 - 1;
    splHeader.lcrtl = 0x120;
    splHeader.mainImageSize = width * height * 2;
    splHeader.noOfAnimationFrames = 0;
    splHeader.animStride = 0;
    splHeader.animLCtrl = 0;
    splHeader.animX = 0;
    splHeader.animY = 0;
    splHeader.animSize = 0;
    splHeader.animInterval = 200;
    splHeader.reserved[0] = 0x0586EF48; //Maybe useless data,
    splHeader.reserved[1] = 0x00000000; //added for easier comparison
    splHeader.reserved[2] = 0x024f97b4; //with manage target output
    splHeader.headerChecksum = 0;

    quint32 chksum = 0;
    for(quint8 i=0; i<(sizeof(splHeader)/sizeof(unsigned long) - 1);i++)
    {
        chksum += ((unsigned long*)&splHeader)[i];
    }
    splHeader.headerChecksum = chksum;

    for(quint8 i=0; i<(sizeof(splashHeader));i++)
    {
        char* charToWrite = (char*)&splHeader+i;
        rawData = rawData.append(charToWrite, sizeof(quint8));
    }

    for(quint16 y=0; y<height; y++)
    {
        for(quint16 x=0; x<width; x++)
        {
            quint32 pix24 = myImageNew->pixel(x, y);
            quint16 pix16 = rgb24to16( pix24 );
            char* charToWrite = (char*)&pix16;
            rawData = rawData.append(charToWrite, sizeof(quint16));
        }
    }

    QFile newDoc(IMGBIN_FNAME);
    if(newDoc.open(QIODevice::WriteOnly))
        newDoc.write(rawData);
    newDoc.close();

    //qDebug() << "MD5: " << fileChecksum("fileName.bin", QCryptographicHash::Md5);

    QFile md5file(IMGBIN_FNAME".md5");
    if(md5file.open(QIODevice::WriteOnly))
    {
        QString md5str = fileChecksum(IMGBIN_FNAME, QCryptographicHash::Md5);
        md5file.write( md5str.toUtf8() );
    }
    md5file.close();
}
/*
 * ImageManager::getFileName
 */
QString ImageManager::getFileName()
{
    return m_fileName;
}
/*
 * ImageManager::setFileName
 */
void ImageManager::setFileName(const QString &fileName)
{
    if (fileName == m_fileName)
        return;

    m_fileName = fileName;
    qDebug() << "###: " << m_fileName;

    m_fileName.replace("///", "//");
    qDebug() << "***: " << m_fileName;

    const QUrl u = QUrl(m_fileName);
    if (u.isValid())
    {
        qDebug() << "Valid URL " ;
        processImage(u);
    }else{
        qDebug() << "the url is invalid";
    }

    emit fileNameChanged();
}
/*
 * ImageManager::setOutWidth
 */
void ImageManager::setOutWidth(const QString &outWidth)
{
    if (outWidth == m_outWidth)
        return;

    m_outWidth = outWidth.toInt();
    emit outWidthChanged();
}
/*
 * ImageManager::getOutWidth
 */
QString ImageManager::getOutWidth()
{
    return ( QString("%1").arg((quint16)m_outWidth, 0, 10).toUpper() );
}
/*
 * ImageManager::setOutHeight
 */
void ImageManager::setOutHeight(const QString &outHeight)
{
    if (outHeight == m_outHeight)
        return;

    m_outHeight = outHeight.toInt();
    emit outHeightChanged();
}
/*
 * ImageManager::getOutHeight()
 */
QString ImageManager::getOutHeight()
{
    return ( QString("%1").arg((quint16)m_outHeight, 0, 10).toUpper() );
}
/*
 * ImageManager::setAspectRatio()
 */
void ImageManager::setAspectRatio(const QString &outAspectRatio)
{
    if(outAspectRatio == "IgnoreAspectRatio")
    {
        qDebug() << "setAspectRatio IgnoreAspectRatio " << outAspectRatio;
        m_ARout = Qt::IgnoreAspectRatio;
    } else if(outAspectRatio == "KeepAspectRatioByExpanding") {
        qDebug() << "setAspectRatio KeepAspectRatioByExpanding " << outAspectRatio;
        m_ARout = Qt::KeepAspectRatioByExpanding;
    } else {
        qDebug() << "setAspectRatio KeepAspectRatio " << outAspectRatio;
        m_ARout = Qt::KeepAspectRatio;
    }
}
