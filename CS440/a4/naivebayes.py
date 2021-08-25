import numpy as np
import math
import collections

class NaiveBayesModel:
  
  def __init__(self, numlabels):
    self.numlabels = numlabels
    self.k = 1
    self.automaticTuning = False

  def train(self, trainingData, trainingLabels, validationData, validationLabels):
    self.features = list(set([f for image in trainingData for f in image.keys()]));
    
    #kgrid = [0.001, 0.01, 0.05, 0.1, 0.5, 1, 5, 10, 20, 50]
    kgrid = [1]

    self.trainAndTune(trainingData, trainingLabels, validationData, validationLabels, kgrid)
  
  def trainAndTune(self, trainingData, trainingLabels, validationData, validationLabels, kgrid):
    prior = collections.Counter()
    conditional_probability = collections.Counter()
    frequency = collections.Counter()

    for label in trainingLabels:
      prior[label] += 1
    total = sum(prior.values(), 0.0)
    for key in prior:
      prior[key] /= total

    for i in range(len(trainingData)):
      image = trainingData[i]
      label = trainingLabels[i]

      for location, value in image.items():
        frequency[(location, label)] += 1
        if value == 1:
          conditional_probability[location, label] += 1

    highest_accuracy = 0

    for k in kgrid:
      k_prior = collections.Counter()
      k_conditional = collections.Counter()
      k_frequency = collections.Counter()

      for key, value in prior.items():
        k_prior[key] = value
      for key, value in conditional_probability.items():
        k_conditional[key] = value
      for key, value in frequency.items():
          k_frequency[key] = value

      for label in range(self.numlabels):
        for location in self.features:
          k_frequency[(location, label)] += k
          k_conditional[(location, label)] += k

      for x, count in k_conditional.items():
        k_conditional[x] = float(count) / k_frequency[x]

      self.prior = k_prior
      self.conditionalProb = k_conditional

      predictions = self.classify(validationData)
      number_correct = 0
      for index in range(len(validationData)):
        if predictions[index] == validationLabels[index]:
          number_correct += 1

      percent_correct = (float(number_correct) / len(validationLabels)) * 100
      #print("Accuracy for k:{} = {}".format(k,percent_correct)) 

      if percent_correct > highest_accuracy:
        highest_accuracy = percent_correct
        self.k = (k_prior, k_conditional, k)

  def calculateProbabilities(self, image):
    logJoint = collections.Counter()

    for label in range(self.numlabels):
      for k,v in self.prior.items():
        if(k == label):
          logJoint[label] = math.log(v)
          break
      for location, value in image.items():
        if value == 0:
          x = 1 - self.conditionalProb[(location, label)]
          logJoint[label] += math.log(x if x > 0 else 1)
        else:
          logJoint[label] += math.log(self.conditionalProb[(location, label)])

    return logJoint
  
  def classify(self, testData):
    guesses = []
    self.posteriors = []
    for image in testData:
      posterior = self.calculateProbabilities(image)
      guesses.append(max(posterior.values()))
      self.posteriors.append(posterior)
    return guesses