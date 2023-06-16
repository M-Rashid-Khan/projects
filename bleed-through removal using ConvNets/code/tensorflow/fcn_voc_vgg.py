import tensorflow as tf
from evalution_metrics import metrics
import tensorflow.contrib.eager as tfe
import numpy as np
tfe.enable_eager_execution()
VGG_Weights_path = "../vgg/vgg16_weights_tf_dim_ordering_tf_kernels_noto"
metrics_obj=metrics()
class buildmodel_vgg(tf.keras.Model):

    def __init__(self):
        super(buildmodel_vgg, self).__init__()
        # print(x.shape)
        self.pool5 = tf.layers.MaxPooling2D(pool_size=(2, 2), strides=(2, 2),padding='valid')
        self.conv1 = tf.layers.Conv2D(filters=4096, kernel_size=(7, 7), strides=(1, 1), padding='same',activation=tf.nn.relu)
        self.conv2 = tf.layers.Conv2D(filters=4096, kernel_size=(1, 1), strides=(1, 1), padding='same',activation=tf.nn.relu)
        self.conv3 = tf.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same',activation=tf.nn.relu)
        self.conv3T1 = tf.layers.Conv2DTranspose(filters=21, kernel_size=(4, 4), strides=(2, 2),padding='same',data_format='channels_last')
        self.conv4 = tf.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same')
        self.conv3T2 = tf.layers.Conv2DTranspose(filters=21, kernel_size=(4,4), strides=(2, 2),padding='same',data_format='channels_last')
        self.conv5 = tf.layers.Conv2D(filters=21, kernel_size=(1, 1), strides=(1, 1), padding='same')
        self.conv3T3 = tf.layers.Conv2DTranspose(filters=21, kernel_size=(16, 16), strides=(8, 8),padding='same' ,data_format='channels_last')


        # return conv_trans_2

    def feed_data(self,x):
        net, mean_pixel=self.net(x)

        conv_final_layer = net["conv5_3"]
        pool5=self.pool5(conv_final_layer)
        conv1 = self.conv1(pool5)
        conv1_drop=tf.nn.dropout(conv1,0.5)
        conv2 = self.conv2(conv1_drop)
        conv2_drop = tf.nn.dropout(conv2, 0.5)
        conv3 = self.conv3(conv2_drop)
        # first transpose layer
        deconv_shape1 = net["pool4"]
        convT1 = self.conv3T1(conv3)
        conv4 = self.conv4(deconv_shape1)
        fuse1 = tf.add(convT1, conv4)
        convT2 = self.conv3T2(fuse1)
        deconv_shape2 = net["pool3"]
        conv5 = self.conv5(deconv_shape2)
        fuse2 = tf.add(convT2, conv5)
        convT3 = self.conv3T3(fuse2)
        #annotation_pred = tf.argmax(convT3, dimension=3, name="prediction")
        return convT3

    def net(self,input_image):
        import scipy
        data_path='./imagenet-vgg-verydeep-19'
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
        data = scipy.io.loadmat(data_path)
        mean = data['normalization'][0][0][0]
        mean_pixel = np.mean(mean, axis=(0, 1))
        weights = data['layers'][0]
        #processed_image = self.preprocess(input_image, mean_pixel)
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

    def _conv_layer(self,input, weights, bias):
        conv = tf.nn.conv2d(input, tf.constant(weights), strides=(1, 1, 1, 1),
                            padding='SAME')
        return tf.nn.bias_add(conv, bias)

    def _pool_layer(self,input):
        return tf.nn.max_pool(input, ksize=(1, 2, 2, 1), strides=(1, 2, 2, 1),
                              padding='SAME')

    def preprocess(self,image, mean_pixel):
        return image - mean_pixel

    def unprocess(self,image, mean_pixel):
        return image + mean_pixel
    def forward_pass(self,inputs):
        logits=self.feed_data(inputs)
        return logits
    def loss_value(self,logits,label):
        #loss = tf.reduce_mean((tf.nn.sparse_softmax_cross_entropy_with_logits(logits=logits,labels=label)))
        cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits_v2(logits=logits, labels=label))
        return cross_entropy
    def mean_IU(self,y,y_pre):
        updated_y_pre = tf.argmax(y_pre, axis=3,
                                  output_type=tf.int32)
        updated_y = tf.argmax(y, axis=3,
                              output_type=tf.int32)
        result=metrics_obj.mean_IU(updated_y_pre,updated_y)
        return result
    def accuacry(self,y,y_pre):
        updated_y_pre=tf.argmax(y_pre, axis=3,
                              output_type=tf.int32)
        updated_y=tf.argmax(y, axis=3,
                              output_type=tf.int32)
        #correct_prediction=tf.equal(updated_y_pre,updated_y)
        #result=tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
        result=metrics_obj.pixel_accuracy(updated_y_pre,updated_y)
        mean_result=metrics_obj.mean_accuracy(updated_y_pre,updated_y)
        return result,mean_result
    def backward_pass(self,x_train,label):
        with tf.device('/GPU:0'):
            #optimizer = tf.train.MomentumOptimizer(0.0001,0.9)
            optimizer=tf.contrib.opt.MomentumWOptimizer(learning_rate=0.0001,
                                               weight_decay=0.0005,
                                               momentum=0.9)
            with tf.GradientTape() as tape:
                logits = self.forward_pass(x_train)
                current_loss = self.loss_value(logits, label)

            grads = tape.gradient(current_loss, self.variables)
            optimizer.apply_gradients(zip(grads, self.variables),global_step=tf.train.get_or_create_global_step())
        return current_loss,logits
    def predict(self, inputs):
        logits = self.feed_data(inputs)
        return tf.argmax(logits, axis=-1)

    def split_valid_test(self,x,y):
        from sklearn.utils import shuffle
        train_rate = 0.75
        index_train = np.random.choice(x.shape[0], int(x.shape[0] * train_rate), replace=False)
        index_test = list(set(range(x.shape[0])) - set(index_train))

        X, Y = shuffle(x, y)
        X_valid, y_valid = X[index_train], Y[index_train]
        X_test, y_test = X[index_test], Y[index_test]
        return X_valid, y_valid,X_test, y_test
    def predict(self,x_test):
        logits=self.forward_pass(x_test)
        return logits
