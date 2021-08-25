import perceptron
import naivebayes
import mira
import numpy as np
import collections
import time
import math

def load_data(filename, type):
  f = None
  width = 0
  height = 0
  dataAmount = 0

  if type == 1:
    width = 28
    height = 28
    dataAmount = 1000
    f = open(filename, "r")

  if type == 2:
    width = 60
    height = 70
    dataAmount = 150
    f = open(filename, "r")

  imageList = []
  for imagenum in range(dataAmount):

    result = []
    listcoord = 0
    for i in range(width*height):
      allText = f.read(1)
      result.append(allText)
      #pixelList = allText.split()

    #print(len(pixelList))
    image = [[' ' for i in range(width)] for j in range(height)]
    for i in range(height):
      for j in range(width):
        if(listcoord == len(result)):
          break;
        #print(listcoord)
        pixel = result[listcoord]
        image[i][j] = pixel
        listcoord += 1
    imageList.append(image)
  return imageList

def load_labels(filename):
  f = open(filename, "r")
  allNums = f.read()
  numList = allNums.split()
  return numList

def digit_feature_extractor(image):
  width = 28
  height = 28

  features = [0]*(width*height)
  k = 0
  for i in range(height):
    for j in range(width):
      if image[i][j] == " ":
        features[k] = 0
      else:
        features[k] = 1
      k += 1
  features = np.array(features)
  #print(features)
  return features

def face_feature_extractor(image):
  width = 60
  height = 70

  features = [0]*(width*height)
  k = 0
  for i in range(height):
    for j in range(width):
      if image[i][j] == " ":
        features[k] = 0
      else:
        features[k] = 1
      k += 1
  features = np.array(features)
  #print(features)
  return features

def NB_extractor(image):
  width = 28
  height = 28

  features = collections.Counter()
  k = 0
  for i in range(height):
    for j in range(width):
      if image[i][j] == " ":
        features[(i,j)] = 0
      else:
        features[(i,j)] = 1
      k += 1
  #features = np.array(features)
  #print(features)
  return features

def NB_extractor_face(image):
  width = 60
  height = 70

  features = collections.Counter()
  k = 0
  for i in range(height):
    for j in range(width):
      if image[i][j] == " ":
        features[(i,j)] = 0
      else:
        features[(i,j)] = 1
      k += 1
  #features = np.array(features)
  #print(features)
  return features

if __name__ == '__main__':

  rawtrainingdata = load_data("digitdata/trainingimages", 1)
  traininglabels = load_labels("digitdata/traininglabels")

  rawtestingdata = load_data("digitdata/testimages", 1)
  testinglabels = load_labels("digitdata/testlabels")

  trainingdata = list(map(digit_feature_extractor, rawtrainingdata))
  testingdata = list(map(digit_feature_extractor, rawtestingdata))

  trainpercent = 100
  numpercent = 10
  predictionList = []
  timelist = []
  for i in range(10):
    newtrainingdata = []
    for j in range(trainpercent):
      newtrainingdata.append(trainingdata[j])
    model = perceptron.PerceptronModel(range(10), 10, 1)
    #print(list(trainingdata))
    #print(imageList)

    start = time.perf_counter()
    #print("Training...")
    model.train(newtrainingdata, traininglabels)
    stop = time.perf_counter()
    #print("Testing...")
    predictions = model.classify(testingdata)

    numcorrect = 0
    for i in range(1000):
      if int(predictions[i]) == int(testinglabels[i]):
        numcorrect += 1
    predpercent = (numcorrect/1000)*100
    totaltime = stop - start
    print("{}% TRAINING PERCEPTRON DIGIT MODEL ACCURACY: {:0.2f}%".format(numpercent, predpercent))
    print("TRAINING TIME: {:0.2f} SECONDS".format(totaltime))

    trainpercent += 100
    numpercent += 10
    predictionList.append(predpercent)
    timelist.append(totaltime)
  meanpred = 0
  for prediction in predictionList:
    meanpred += prediction
  meanpred = meanpred/10
  sdlist = []
  for prediction in predictionList:
    sdiff = (prediction - meanpred)**2
    sdlist.append(sdiff)
  meandiffs = 0
  for sd in sdlist:
    meandiffs += sd
  meandiffs = math.sqrt(meandiffs/10)
  meantime = 0
  for traintime in timelist:
    meantime += traintime
  meantime = meantime/10
  print("AVERAGE ACCURACY: {:0.2f}%".format(meanpred))
  print("AVERAGE TRAINING TIME: {:0.2f} SECONDS".format(meantime))
  print("STANDARD DEVIATION: {:0.2f}".format(meandiffs))
  print("\n")

  rawtrainingdata = load_data("facedata/facedatatrain", 2)
  traininglabels = load_labels("facedata/facedatatrainlabels")

  rawtestingdata = load_data("facedata/facedatatest", 2)
  testinglabels = load_labels("facedata/facedatatestlabels")

  trainingdata = list(map(face_feature_extractor, rawtrainingdata))
  testingdata = list(map(face_feature_extractor, rawtestingdata))

  trainpercent = 15
  numpercent = 10
  predictionList = []
  timelist = []
  for i in range(10):
    newtrainingdata = []
    for j in range(trainpercent):
      newtrainingdata.append(trainingdata[j])
    model = perceptron.PerceptronModel(range(2), 10, 2)
    #print(list(trainingdata))
    #print(imageList)

    start = time.perf_counter()
    #print("Training...")
    model.train(newtrainingdata, traininglabels)
    stop = time.perf_counter()
    #print("Testing...")
    predictions = model.classify(testingdata)

    numcorrect = 0
    for i in range(150):
      if int(predictions[i]) == int(testinglabels[i]):
        numcorrect += 1
    predpercent = (numcorrect/150)*100
    totaltime = stop - start
    print("{}% TRAINING PERCEPTRON FACE MODEL ACCURACY: {:0.2f}%".format(numpercent, predpercent))
    print("TRAINING TIME: {:0.2f} SECONDS".format(totaltime))
    trainpercent += 15
    numpercent += 10
    predictionList.append(predpercent)
    timelist.append(totaltime)
  meanpred = 0
  for prediction in predictionList:
    meanpred += prediction
  meanpred = meanpred/10
  meantime = 0
  sdlist = []
  for prediction in predictionList:
    sdiff = (prediction - meanpred)**2
    sdlist.append(sdiff)
  meandiffs = 0
  for sd in sdlist:
    meandiffs += sd
  meandiffs = math.sqrt(meandiffs/10)
  for traintime in timelist:
    meantime += traintime
  meantime = meantime/10
  print("AVERAGE ACCURACY: {:0.2f}%".format(meanpred))
  print("AVERAGE TRAINING TIME: {:0.2f} SECONDS".format(meantime))
  print("STANDARD DEVIATION: {:0.2f}".format(meandiffs))
  print("\n")

  rawtrainingdata = load_data("digitdata/trainingimages", 1)
  traininglabels = load_labels("digitdata/traininglabels")

  rawvalidationdata = load_data("digitdata/validationimages", 1)
  validationlabels = load_labels("digitdata/validationlabels")

  rawtestingdata = load_data("digitdata/testimages", 1)
  testinglabels = load_labels("digitdata/testlabels")

  trainingdata = list(map(NB_extractor, rawtrainingdata))
  validationdata = list(map(NB_extractor, rawvalidationdata))
  testingdata = list(map(NB_extractor, rawtestingdata))

  trainpercent = 100
  numpercent = 10
  predictionList = []
  timelist = []
  for i in range(10):
    newtrainingdata = []
    for j in range(trainpercent):
      newtrainingdata.append(trainingdata[j])
    model = naivebayes.NaiveBayesModel(10)

    start = time.perf_counter()
    #print("Training...")
    model.train(newtrainingdata, traininglabels, validationdata, validationlabels)
    stop = time.perf_counter()
    #print("Testing...")
    predictions = model.classify(testingdata)

    numcorrect = 0
    for i in range(1000):
      if int(predictions[i]) == int(testinglabels[i]):
        numcorrect += 1
    predpercent = (numcorrect/1000)*100
    totaltime = stop - start
    print("{}% TRAINING NAIVE BAYES DIGIT MODEL ACCURACY: {:0.2f}%".format(numpercent, predpercent))
    print("TRAINING TIME: {:0.2f} SECONDS".format(totaltime))
    trainpercent += 100
    numpercent += 10
    predictionList.append(predpercent)
    timelist.append(totaltime)
  meanpred = 0
  for prediction in predictionList:
    meanpred += prediction
  meanpred = meanpred/10
  sdlist = []
  for prediction in predictionList:
    sdiff = (prediction - meanpred)**2
    sdlist.append(sdiff)
  meandiffs = 0
  for sd in sdlist:
    meandiffs += sd
  meandiffs = math.sqrt(meandiffs/10)
  meantime = 0
  for traintime in timelist:
    meantime += traintime
  meantime = meantime/10
  print("AVERAGE ACCURACY: {:0.2f}%".format(meanpred))
  print("AVERAGE TRAINING TIME: {:0.2f} SECONDS".format(meantime))
  print("STANDARD DEVIATION: {:0.2f}".format(meandiffs))
  print("\n")

  rawtrainingdata = load_data("facedata/facedatatrain", 2)
  traininglabels = load_labels("facedata/facedatatrainlabels")

  rawvalidationdata = load_data("facedata/facedatavalidation", 2)
  validationlabels = load_labels("facedata/facedatavalidationlabels")

  rawtestingdata = load_data("facedata/facedatatest", 2)
  testinglabels = load_labels("facedata/facedatatestlabels")

  trainingdata = list(map(NB_extractor_face, rawtrainingdata))
  validationdata = list(map(NB_extractor_face, rawvalidationdata))
  testingdata = list(map(NB_extractor_face, rawtestingdata))

  trainpercent = 15
  numpercent = 10
  predictionList = []
  timelist = []
  for i in range(10):
    newtrainingdata = []
    for j in range(trainpercent):
      newtrainingdata.append(trainingdata[j])
    model = naivebayes.NaiveBayesModel(2)

    start = time.perf_counter()
    #print("Training...")
    model.train(trainingdata, traininglabels, validationdata, validationlabels)
    stop = time.perf_counter()
    #print("Testing...")
    predictions = model.classify(testingdata)

    numcorrect = 0
    for i in range(150):
      if int(predictions[i]) == int(testinglabels[i]):
        numcorrect += 1
    predpercent = (numcorrect/150)*100
    totaltime = stop - start
    print("{}% TRAINING NAIVE BAYES FACE MODEL ACCURACY: {:0.2f}%".format(numpercent, predpercent))
    print("TRAINING TIME: {:0.2f} SECONDS".format(totaltime))
    trainpercent += 15
    numpercent += 10
    predictionList.append(predpercent)
    timelist.append(totaltime)
  meanpred = 0
  for prediction in predictionList:
    meanpred += prediction
  meanpred = meanpred/10
  sdlist = []
  for prediction in predictionList:
    sdiff = (prediction - meanpred)**2
    sdlist.append(sdiff)
  meandiffs = 0
  for sd in sdlist:
    meandiffs += sd
  meandiffs = math.sqrt(meandiffs/10)
  meantime = 0
  for traintime in timelist:
    meantime += traintime
  meantime = meantime/10
  print("AVERAGE ACCURACY: {:0.2f}%".format(meanpred))
  print("AVERAGE TRAINING TIME: {:0.2f} SECONDS".format(meantime))
  print("STANDARD DEVIATION: {:0.2f}".format(meandiffs))
  print("\n")

  rawtrainingdata = load_data("digitdata/trainingimages", 1)
  traininglabels = load_labels("digitdata/traininglabels")

  rawvalidationdata = load_data("digitdata/validationimages", 1)
  validationlabels = load_labels("digitdata/validationlabels")

  rawtestingdata = load_data("digitdata/testimages", 1)
  testinglabels = load_labels("digitdata/testlabels")

  trainingdata = list(map(digit_feature_extractor, rawtrainingdata))
  validationdata = list(map(digit_feature_extractor, rawvalidationdata))
  testingdata = list(map(digit_feature_extractor, rawtestingdata))

  trainpercent = 100
  numpercent = 10
  predictionList = []
  timelist  = []
  for i in range(10):
    newtrainingdata = []
    for j in range(trainpercent):
      newtrainingdata.append(trainingdata[j])
    model = mira.MiraModel(range(10), 10, 1)

    start = time.perf_counter()
    #print("Training...")
    model.train(newtrainingdata, traininglabels, validationdata, validationlabels)
    stop = time.perf_counter()
    #print("Testing...")
    predictions = model.classify(testingdata)

    numcorrect = 0
    for i in range(1000):
      if int(predictions[i]) == int(testinglabels[i]):
        numcorrect += 1
    predpercent = (numcorrect/1000)*100
    totaltime = stop - start
    print("{}% TRAINING MIRA DIGIT MODEL ACCURACY: {:0.2f}%".format(numpercent, predpercent))
    print("TRAINING TIME: {:0.2f} SECONDS".format(totaltime))
    trainpercent += 100
    numpercent += 10
    predictionList.append(predpercent)
    timelist.append(totaltime)
  meanpred = 0
  for prediction in predictionList:
    meanpred += prediction
  meanpred = meanpred/10
  sdlist = []
  for prediction in predictionList:
    sdiff = (prediction - meanpred)**2
    sdlist.append(sdiff)
  meandiffs = 0
  for sd in sdlist:
    meandiffs += sd
  meandiffs = math.sqrt(meandiffs/10)
  meantime = 0
  for traintime in timelist:
    meantime += traintime
  meantime = meantime/10
  print("AVERAGE ACCURACY: {:0.2f}%".format(meanpred))
  print("AVERAGE TRAINING TIME: {:0.2f} SECONDS".format(meantime))
  print("STANDARD DEVIATION: {:0.2f}".format(meandiffs))
  print("\n")

  rawtrainingdata = load_data("facedata/facedatatrain", 2)
  traininglabels = load_labels("facedata/facedatatrainlabels")

  rawvalidationdata = load_data("facedata/facedatavalidation", 2)
  validationlabels = load_labels("facedata/facedatavalidationlabels")

  rawtestingdata = load_data("facedata/facedatatest", 2)
  testinglabels = load_labels("facedata/facedatatestlabels")

  trainingdata = list(map(face_feature_extractor, rawtrainingdata))
  validationdata = list(map(face_feature_extractor, rawvalidationdata))
  testingdata = list(map(face_feature_extractor, rawtestingdata))

  trainpercent = 15
  numpercent = 10
  predictionList = []
  totaltime = []
  for i in range(10):
    newtrainingdata = []
    for j in range(trainpercent):
      newtrainingdata.append(trainingdata[j])
    model = mira.MiraModel(range(2), 10, 2)
    #print(list(trainingdata))
    #print(imageList)

    start = time.perf_counter()
    #print("Training...")
    model.train(newtrainingdata, traininglabels, validationdata, validationlabels)
    stop = time.perf_counter()
    #print("Testing...")
    predictions = model.classify(testingdata)

    numcorrect = 0
    for i in range(150):
      if int(predictions[i]) == int(testinglabels[i]):
        numcorrect += 1
    predpercent = (numcorrect/150)*100
    totaltime = stop - start
    print("{}% TRAINING MIRA FACE MODEL ACCURACY: {:0.2f}%".format(numpercent, predpercent)) 
    print("TRAINING TIME: {:0.2f} SECONDS".format(totaltime))
    trainpercent += 15
    numpercent += 10
    predictionList.append(predpercent)
    timelist.append(totaltime)
  meanpred = 0
  for prediction in predictionList:
    meanpred += prediction
  meanpred = meanpred/10
  sdlist = []
  for prediction in predictionList:
    sdiff = (prediction - meanpred)**2
    sdlist.append(sdiff)
  meandiffs = 0
  for sd in sdlist:
    meandiffs += sd
  meandiffs = math.sqrt(meandiffs/10)
  meantime = 0
  for traintime in timelist:
    meantime += traintime
  meantime = meantime/10
  print("AVERAGE ACCURACY: {:0.2f}%".format(meanpred))
  print("AVERAGE TRAINING TIME: {:0.2f} SECONDS".format(meantime))
  print("STANDARD DEVIATION: {:0.2f}".format(meandiffs))
  print("\n")