import numpy as np

class PerceptronModel:

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

  def train(self, trainingdata, traininglabels):
    #self.features = trainingdata[0].keys()
    numErrors = 0

    for iteration in range(self.iterations):
      
      #print("Starting iteration {}".format(iteration))

      for i in range(len(trainingdata)):
        topScore = -1
        bestLabel = None
        currentImage = trainingdata[i]

        for label in self.numlabels:
          #print(currentImage)
          #print(self.weights[label])
          #currentImageT = currentImage.transpose()
          result = np.sum(np.dot(self.weights[label], currentImage))

          #result = currentImage * self.weights[label]
          if result > topScore:
            topScore = result
            bestLabel = label

        realLabel = int(traininglabels[i])
        if bestLabel != realLabel:
          numErrors += 1
          self.weights[realLabel] =  np.add(self.weights[realLabel], currentImage)
          self.weights[bestLabel] = np.subtract(self.weights[bestLabel], currentImage)

      #print("Number of Errors: {}".format(numErrors))
      numErrors = 0
  
  def classify(self, images):
    predictions = []
    for image in images:
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