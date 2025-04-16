from keras import models
import os

def loadModel(signal, cnn):
    name = os.path.dirname(os.path.abspath(__file__)) + '/models2/cnnmodel' + ('I' if cnn == 'CNN2' else '') + signal
    print(name)
    model = models.load_model(name)
    model.summary()
    return model