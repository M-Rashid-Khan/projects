import tensorflow as tf
tf.compat.v1.enable_eager_execution
from VOC2012 import VOC2012
vgg_path= 'C:/users/rashi/PycharmProjects/Research1/networks/vgg16_weights.npy'
VGG_Weights_path = "./vgg/vgg16_weights_tf_dim_ordering_tf_kernels_notop.h5"
print("tensorflow version", tf.__version__)
#import TensorflowUtils as utils
import numpy as np

class FCN(tf.keras.Model):
  def net(self, input_image):
    #import scipy
    from scipy import io
    data_path = 'C:/Users/rashi/PycharmProjects/Research1/networks/imagenet-vgg-verydeep-19'
    layers = (
      'conv1_1', 'relu1_1', 'conv1_2', 'relu1_2', 'pool1',
      'conv2_1', 'relu2_1', 'conv2_2', 'relu2_2', 'pool2',
      'conv3_1', 'relu3_1', 'conv3_2', 'relu3_2', 'conv3_3',
      'relu3_3', 'conv3_4', 'relu3_4', 'pool3',
      'conv4_1', 'relu4_1', 'conv4_2', 'relu4_2', 'conv4_3',
      'relu4_3', 'conv4_4', 'relu4_4', 'pool4',
      'conv5_1', 'relu5_1', 'conv5_2', 'relu5_2', 'conv5_3',
      'relu5_3', 'conv5_4', 'relu5_4'
    )
    data = io.loadmat(data_path)
    #model_data = utils.get_model_data(FLAGS.model_dir, MODEL_URL)
    mean = data['normalization'][0][0][0]
    mean_pixel = np.mean(mean, axis=(0, 1))
    weights = data['layers'][0]
    # processed_image = self.preprocess(input_image, mean_pixel)
    net = {}
    current = input_image
    for i, name in enumerate(layers):
      kind = name[:4]
      if kind == 'conv':
        kernels, bias = weights[i][0][0][0][0]
        # matconvnet: weights are [width, height, in_channels, out_channels]
        # tensorflow: weights are [height, width, in_channels, out_channels]
        kernels = np.transpose(kernels, (1, 0, 2, 3))
        bias = bias.reshape(-1)
        current = self._conv_layer(current, kernels, bias)
      elif kind == 'relu':
        current = tf.nn.relu(current)
      elif kind == 'pool':
        current = self._pool_layer(current)
      net[name] = current

    assert len(net) == len(layers)
    return net, mean_pixel

  def _conv_layer(self, input, weights, bias):
    conv = tf.nn.conv2d(input, tf.constant(weights), strides=(1, 1, 1, 1),
                        padding='SAME')
    return tf.nn.bias_add(conv, bias)
  def _pool_layer(self,input):
        return tf.nn.max_pool(input, ksize=(1, 2, 2, 1), strides=(1, 2, 2, 1),
                              padding='SAME')
  def __init__(self):
    super(FCN, self).__init__()
    # self.conv1_1 = tf.keras.layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu')
    # self.conv1_2 = tf.keras.layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu')
    # self.pool1 = tf.keras.layers.MaxPool2D(pool_size=2)
    #
    # self.conv2_1 = tf.keras.layers.Conv2D(filters=128, kernel_size=3, padding='same', activation='relu')
    # self.conv2_2 = tf.keras.layers.Conv2D(filters=128, kernel_size=3, padding='same', activation='relu')
    # self.pool2 = tf.keras.layers.MaxPool2D(pool_size=2)
    #
    # self.conv3_1 = tf.keras.layers.Conv2D(filters=256, kernel_size=3, padding='same', activation='relu')
    # self.conv3_2 = tf.keras.layers.Conv2D(filters=256, kernel_size=3, padding='same', activation='relu')
    # self.conv3_3 = tf.keras.layers.Conv2D(filters=256, kernel_size=3, padding='same', activation='relu')
    # self.pool3 = tf.keras.layers.MaxPool2D(pool_size=2)
    # #conv2D of pool3 for skip connection in FCN8
    # self.conv4_1 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
    # self.conv4_2 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
    # self.conv4_3 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
    # self.pool4 = tf.keras.layers.MaxPool2D(pool_size=2)
    # #conv2D of pool4 and conv2DT for skip connection in FCN8
    # self.conv5_1 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
    # self.conv5_2 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
    # self.conv5_3 = tf.keras.layers.Conv2D(filters=512, kernel_size=3, padding='same', activation='relu')
    ### Decoder layers after VGG
    self.pool5 = tf.keras.layers.MaxPool2D(pool_size=2)
    # size 7x7x512=7162
    self.conv1 = tf.keras.layers.Conv2D(filters=4096, kernel_size=(7, 7), strides=(1, 1), padding='same', activation='relu')
    self.conv2 = tf.keras.layers.Conv2D(filters=4096, kernel_size=(1, 1), strides=(1, 1), padding='same', activation='relu')
    self.conv3 = tf.keras.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same', activation='relu')
    self.conv3T1 = tf.keras.layers.Convolution2DTranspose( filters = 21, kernel_size = 4, strides = 2 , padding = 'same', data_format = 'channels_last')

    self.conv4 = tf.keras.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same')
    self.conv3T2 = tf.keras.layers.Convolution2DTranspose(filters= 21, kernel_size =4, strides=2, padding ='same', data_format = 'channels_last')
    self.conv5 = tf.keras.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same')
    self.conv3T3 = tf.keras.layers.Convolution2DTranspose(filters=21, kernel_size=(16, 16), strides=(8, 8), padding='same', data_format='channels_last')

  def call(self, inputs):
    net, mean_pixel = self.net(inputs)
    conv_final_layer = net["conv5_3"]          # 14x14x512
    pool5 = self.pool5(conv_final_layer)       #7x7x512
    conv1 = self.conv1(pool5)                  #7x7x4096
    conv1_drop = tf.nn.dropout(conv1, 0.5)     #7x7x4096
    conv2 = self.conv2(conv1_drop)             #7x7x4096
    conv2_drop = tf.nn.dropout(conv2, 0.5)      #7x7x4096
    conv3 = self.conv3(conv2_drop)              #7x7x21
    # first transpose layer
    deconv_shape1 = net["pool4"]                #14x14x512
    convT1 = self.conv3T1(conv3)                #14x14x21
    conv4 = self.conv4(deconv_shape1)           #14x14x21
    fuse1 = tf.add(convT1, conv4)               #14x14x21
    convT2 = self.conv3T2(fuse1)                #28x28x21
    deconv_shape2 = net["pool3"]                #28x28x256
    conv5 = self.conv5(deconv_shape2)           #28x28x21
    fuse2 = tf.add(convT2, conv5)               #28x28x21
    convT3 = self.conv3T3(fuse2)                #224x224x21

    # net, mean_pixel = self.net(inputs)
    # x = net["conv5_3"]
    # x = self.conv1_1(inputs)
    # x = self.conv1_2(x)
    # layer_1 = self.pool1(x)
    #
    # x = self.conv2_1(layer_1)
    # x = self.conv2_2(x)
    # layer_2 = self.pool2(x)
    #
    # x = self.conv3_1(layer_2)
    # x = self.conv3_2(x)
    # x = self.conv3_3(x)
    # layer_3 = self.pool3(x)
    # pool311 = tf.keras.layers.Conv2D(filters= 21, kernel_size=(1,1), activation= 'relu')(layer_3)
    #
    # x = self.conv4_1(layer_3)
    # x = self.conv4_2(x)
    # x = self.conv4_3(x)
    # layer_4 = self.pool4(x)
    # pool411 = tf.keras.layers.Conv2D(filters= 21, kernel_size= (1,1), activation= 'relu')(layer_4)
    # pool411_2 = tf.keras.layers.Convolution2DTranspose(filters= 21, kernel_size = (2,2), strides= (2,2))(pool411)
    #
    # x = self.conv5_1(layer_4)
    # x = self.conv5_2(x)
    # x = self.conv5_3(x)
    # layer_5 = self.pool5(x)
    # deconv_shape1 = net["pool4"]
    #
    # layer_6= self.conv6(layer_5)
    # layer_7= self.conv7(layer_6)
    # layer_8=self.conv8(layer_7)
    # layer_9=self.conv9_T(layer_8)
    # # convT1 = self.conv3T1(conv3)
    #
    # layer_10=self.conv10(layer_9)
    # layer_11=self.conv11_T(layer_10)
    #Here the skip connection
    #skip_connection =tf.keras.layers.add([layer_11,pool411_2,pool311])

    # layer_12 = tf.keras.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same')(skip_connection)
    # final_layer = tf.keras.layers.Convolution2DTranspose(filters=21, kernel_size=(16, 16), strides=(8, 8),padding='same', data_format='channels_last')(layer_12)
    # layer_12=self.conv12(layer_11)
    # layer_13=self.conv13_T(layer_12)

    return  convT3



  #provided in VOC2012 script get_batch_train(self, batch_size),read_train_names(self),read_val_names(self):,read_aug_names(self),get_batch_val(self, batch_size),
  #get_batch_aug(self, batch_size):,

# import numpy as np
# voc2012 = VOC2012('./VOC2012/')
# voc2012.load_all_data()
# # for i in range(0, voc2012.train_images.shape[0]):
# obj1 = FCN()
# train_images = np.array(voc2012.train_images.value, dtype= np.float32)
# obj1.call(train_images)


