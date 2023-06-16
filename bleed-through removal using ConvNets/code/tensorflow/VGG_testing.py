import tensorflow as tf
import tensorflow.contrib.eager as tfe
tfe.enable_eager_execution()

class vgg_test(tf.keras.Model):

    def __init__(self):
        super(vgg_test,self).__init__()
        self.conv1_1= tf.keras.layers.Conv2D(filters=64,kernel_size=3,padding='same',activation='relu')
        self.conv1_2= tf.keras.layers.Conv2D(filters=64,kernel_size=3,padding='same',activation='relu')
        self.pool1=tf.keras.layers.MaxPool2D(pool_size=2)

        self.conv2_1= tf.keras.layers.Conv2D(filters=128,kernel_size=3,padding='same',activation='relu')
        self.conv2_2= tf.keras.layers.Conv2D(filters=128,kernel_size=3,padding='same',activation='relu')
        self.pool2=tf.keras.layers.MaxPool2D(pool_size=2)

        self.conv3_1= tf.keras.layers.Conv2D(filters=256,kernel_size=3,padding='same',activation='relu')
        self.conv3_2= tf.keras.layers.Conv2D(filters=256,kernel_size=3,padding='same',activation='relu')
        self.conv3_3 = tf.keras.layers.Conv2D(filters=256, kernel_size=3, padding='same', activation='relu')
        self.pool3 = tf.keras.layers.MaxPool2D(pool_size=2)

        self.conv4_1= tf.keras.layers.Conv2D(filters=512,kernel_size=3,padding='same',activation='relu')
        self.conv4_2= tf.keras.layers.Conv2D(filters=512,kernel_size=3,padding='same',activation='relu')
        self.conv4_3= tf.keras.layers.Conv2D(filters=512,kernel_size=3,padding='same',activation='relu')
        self.pool4 = tf.keras.layers.MaxPool2D(pool_size=2)

        self.conv5_1 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
        self.conv5_2 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
        self.conv5_3 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
        self.pool5 = tf.keras.layers.MaxPool2D(pool_size=2)
        #size 7x7x512=7162

        self.flatten = tf.keras.layers.Flatten() #7162
        self.fc_1= tf.keras.layers.Dense(units=4096,activation='relu')
        self.fc_2 = tf.keras.layers.Dense(units=1000,activation='softmax')

    def call(self,image_size):
        #x=tf.constant(image_size,name='inputs')
        #x=tf.constant(1,shape=(1,224,224))
        x=self.conv1_1(image_size)
        x=self.conv1_2(x)
        x=self.pool1(x)

        x = self.conv2_1(x)
        x = self.conv2_2(x)
        x = self.pool2(x)

        x = self.conv3_1(x)
        x = self.conv3_2(x)
        x = self.conv3_3(x)
        x = self.pool3(x)

        x = self.conv4_1(x)
        x = self.conv4_2(x)
        x = self.conv4_3(x)
        x = self.pool4(x)

        x = self.conv5_1(x)
        x = self.conv5_2(x)
        x = self.conv5_3(x)
        x = self.pool5(x)

        x= self.flatten(x)
        x=self.fc_1(x)
        x=self.fc_2(x)
        return  x

#image_size = tf.constant(1,shape=(1,224,224))

import numpy as np

obj1=vgg_test()
image = np.zeros((1,224,224, 3), dtype= np.float32)
#obj1(image)
obj1.call(image)


