import types
from urllib import request
import requests
import urllib.parse
import json
import os
import threading

host = "https://museum.morview.com/"
url = "https://api.morview.com/v2.1/exhibits?museum_id=4"

infourl = "https://api.morview.com/v2.1/exhibitInfo?exhibit_id="
commenturl = "https://api.morview.com/v2.1/exhibitComments?exhibit_id="

lovalsavepath = "/Users/chenwenjuan/Desktop/down_load/local_api/"



#利用urllib2获取网络数据
def registerUrl():

 req = requests.get(url)

 content = req.json()

 if content :
  dataary = content["data"]["res"]
  for i, val in enumerate(dataary):

   reallist = val["exhibits"]
  # list = list(dataary)
   for i, val in enumerate(reallist):

       exhibitid = val["exhibit_id"]
       req = requests.get(infourl + exhibitid)

       content = req.json()
       if content:
           responsedata = content["data"]
           savedata = str(content).replace('\'', '\"')
           # 保存展品详情的文字接口
           saveJsonFile("%sexhibit/" % (lovalsavepath), savedata, exhibitid)

           audio = responsedata["audio"]  # 保存展品详情的语音文件

           images = responsedata["images"]

           vedio = responsedata["video"]

           threading.Thread(target=saveAudio, args=(audio,)).start()
           # saveAudio(audio) #保存语音

           # saveImages(images) #保存图片（大图和小图）
           threading.Thread(target=saveImages, args=(images,)).start()

           # saveVedio(vedio) #保存视频
           threading.Thread(target=saveVedio, args=(vedio,)).start()

           # saveComment(exhibitid) #保存评论
           threading.Thread(target=saveComment,args=(exhibitid,)).start()


##### 保存文件
def saveComment(exhibitid):
    pageindex = 1;
    totalcomment = []
    hasnext = True
    while hasnext:
        reqcomment = requests.get(commenturl + exhibitid + "&page_index=" + str(pageindex))  # 下载评论

        if reqcomment:
            commentdata = reqcomment.json()
            if commentdata:  # 保存评论数据
                comment = commentdata["data"]["comments"]
                if comment:

                    totalcomment.extend(comment)
                else:

                    commentdata["data"]["comments"] = totalcomment

                    savedata = str(commentdata).replace('\'', '\"')

                    saveJsonFile("%scomment/" % (lovalsavepath), savedata, exhibitid)
                    hasnext = False
        else:
            saveJsonFile("%scomment/" % (lovalsavepath), "", exhibitid)
            hasnext = False

        pageindex += 1

def saveVedio(vedio):
    if vedio:
        vediourl = vedio["videourl"]
        vedioimg = vedio["img"]
        if vediourl != "":
            downimgurl = '%s%s' % (host, vedioimg)
            downvediourl = '%s%s' % (host, vediourl)
            savevedio = "%s%s" % (lovalsavepath, vediourl)
            saveimg = "%s%s" % (lovalsavepath, vedioimg)
            createFilePath(savevedio)
            createFilePath(saveimg)
            urllib.request.urlretrieve(downvediourl, savevedio)  # 下载视频
            urllib.request.urlretrieve(downimgurl, saveimg)  # 下载图片


def saveAudio(audio):
    if audio:
        for i, val in enumerate(audio):
            if val["filename"]:
                filename = val["filename"];
                newurl = '%s%s' % (host, val["filename"])
                savepath = "%s%s" % (lovalsavepath, filename)
                createFilePath(savepath)
                urllib.request.urlretrieve(newurl, savepath)  # 下载语音

def saveImages(images):
    if images:
        for i, val in enumerate(images):
            imgary = val.split(".")

            bigpicurl = imgary[0][0:len(imgary[0]) - 2] + "." + imgary[1]

            bignewurl = '%s%s' % (host, bigpicurl)

            newurl = '%s%s' % (host, val)
            savepath = "%s%s" % (lovalsavepath, val)
            createFilePath(savepath)
            urllib.request.urlretrieve(newurl, savepath)  # 下载图片

            savebigpath = "%s%s" % (lovalsavepath, bigpicurl)
            createFilePath(savebigpath)

            urllib.request.urlretrieve(bignewurl, savebigpath)  # 下载大图片

def createFilePath(pathname):
    dirname = os.path.dirname(pathname)
    if not os.path.exists(dirname):
        os.makedirs(dirname)



def saveJsonFile(loalpath,fileData,filename):
  path = "%s%s.json" % (loalpath,filename)
  dirname = os.path.dirname(path)

  if not os.path.exists(dirname):
      os.makedirs(dirname)
  else:
      file = open(path,"w")
      file.write(fileData)
      file.close()

registerUrl()
