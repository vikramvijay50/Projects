import numpy as np
import math
import collections

class MiraModel:

  def __init__(self, numlabels, iterations, type):
    self.numlabels = numlabels
    self.iterations = iterations
    if type == 1:
      self.weights = np.empty(10, dtype=object)
    if type == 2:
      self.weights = np.empty(2, dtype=object)
    for label in numlabels:
      if type == 1:
        self.weights[label] = np.random.rand(28*28)
      elif type == 2:
        self.weights[label] = np.zeros([70*60])

  def train(self, trainingData, trainingLabels, validationData, validationLabels):

    Cgrid = [0.001, 0.002, 0.004, 0.008]

    return self.trainAndTune(trainingData, trainingLabels, validationData, validationLabels, Cgrid)   

  def trainAndTune(self, trainingData, trainingLabels, validationData, validationLabels, Cgrid):
    numErrors = 0
    for iteration in range(self.iterations):
      if iteration > 0:
        #print ("Number of Errors: {}".format(numErrors))
        numErrors = 0
      #print ("Starting iteration {}...".format(iteration))

      for i in range(len(trainingData)):
        topScore = -1
        bestLabel = None
        currentImage = trainingData[i]

        for label in self.numlabels:
          result = np.sum(np.dot(self.weights[label], currentImage))

          #result = currentImage * self.weights[label]
          if result > topScore:
            topScore = result
            bestLabel = label

        realLabel = int(trainingLabels[i])
        if bestLabel != realLabel:
          numErrors += 1
          data = currentImage
          t = np.multiply(np.divide(np.add(np.multiply(np.subtract(self.weights[bestLabel], self.weights[realLabel]), data), 1.0), 2.0), (data * data))
          data = np.multiply(data, t)
          self.weights[realLabel] = np.add(self.weights[realLabel], data)
          self.weights[bestLabel] = np.subtract(self.weights[bestLabel], data)

  def classify(self, data):
    predictions = []
    for image in data:
      topScore = -1
      bestLabel = None
      for i in self.numlabels:
        #vector[i] = self.weights[i] * image
        #imageT = image.transpose()
        result = np.sum(np.dot(image, self.weights[i]))
        if result > topScore:
          topScore = result
          bestLabel = i
      predictions.append(bestLabel)
    return predictions