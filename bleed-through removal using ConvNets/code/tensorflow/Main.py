from FCN import FCN
#from dataset import dataset
import os
import numpy as np
from  VOC2012 import VOC2012
import matplotlib.pyplot as plt
from keras.preprocessing.image import ImageDataGenerator
import tensorflow as tf

 ###################################sequential model################################
class main():
    def test_validate(self,images, labels, parameter):
        loss_object = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
        accuracy_object = tf.metrics.Accuracy()
        feedForwardCompuation = self.network(images, training=True)
        self.y_predi.append(feedForwardCompuation)
        loss_value = loss_object(labels, feedForwardCompuation)
        accuracy = accuracy_object(tf.argmax(feedForwardCompuation, axis=3, output_type=tf.int32), labels)
        print(parameter+" Set Loss: {:.4f},accuracy: {:.4f}".format(loss_value, accuracy))
        return accuracy_object.result(),feedForwardCompuation

    def feedForward(self,images, labels, epoch):
        accuracy_object = tf.metrics.Accuracy()
        loss_object = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
        with tf.GradientTape() as self.tape:
            feedForwardCompuation = self.network(images, training=True)
            ####Calculate Loss
            self.loss_value = loss_object(labels, feedForwardCompuation)
            accuracy = accuracy_object(tf.argmax(feedForwardCompuation, axis=3, output_type=tf.int32), labels)
            print("Epoch # "+ str(epoch)+" Minibatch Loss: {:.4f},accuracy: {:.4f}".format(self.loss_value,accuracy))
            self.train_acc_his.append(accuracy)
            self.train_loss_his.append(self.loss_value)

    def BackwardPropagation(self):
        grads = self.tape.gradient(self.loss_value, self.network.trainable_variables)
        self.optimizer.apply_gradients(zip(grads, self.network.trainable_variables))

    def IoU(Yi, y_predi):
        ## mean Intersection over Union
        ## Mean IoU = TP/(FN + TP + FP)

        IoUs = []
        Nclass = int(np.max(Yi)) + 1
        for c in range(Nclass):
            TP = np.sum((Yi == c) & (y_predi == c))
            FP = np.sum((Yi != c) & (y_predi == c))
            FN = np.sum((Yi == c) & (y_predi != c))
            IoU = TP / float(TP + FP + FN)
            print("class {:02.0f}: #TP={:6.0f}, #FP={:6.0f}, #FN={:5.0f}, IoU={:4.3f}".format(c, TP, FP, FN, IoU))
            IoUs.append(IoU)
        mIoU = np.mean(IoUs)
        print("_________________")
        print("Mean IoU: {:4.3f}".format(mIoU))


    def train(self):
        #########Training###################
        for epoch in range(1,4):
            generator = ImageDataGenerator()
            counter = 0
            # generator.fl
            for images, labels in generator.flow(self.train_images, self.train_labels, batch_size=self.batch_size, shuffle=True):
                self.feedForward(images,labels, epoch)
                self.BackwardPropagation()
                #break
                counter += 1
                if(counter == len(self.train_images)/self.batch_size):
                    break
            print ('Epoch {} finished'.format(epoch))
            self.network.save_weights(self.checkPointPath + '/' + str(epoch).format(epoch=epoch))

            ##############################Validation Check#################################
            val_generator = ImageDataGenerator()
            counter = 0
            for images, labels in val_generator.flow(self.val_images, self.val_labels, batch_size=self.batch_size, shuffle=True):
                acc = (self.test_validate(images, labels, 'validate'))
                #break
                counter += 1
                if (counter >= len(self.val_images) / self.batch_size):
                    break
            # acc= acc.result
            self.val_acc.append(acc)
            #self.weight_dict[float(acc)] = self.network.get_weights()   ####key is accuracy and weights are items
            self.weight_dict[map(float,acc)] = self.network.get_weights()
            if(self.patience_ctr >= 3):
                diff = []
                diff.append(self.val_acc[epoch - 2] - self.val_acc[epoch - 3])
                diff.append(self.val_acc[epoch - 1] - self.val_acc[epoch - 2])
                if (diff[0] <= 0.0001 and diff[1] <= 0.0001 or (max(self.val_acc[epoch - 3], self.val_acc[epoch - 2], self.val_acc[epoch - 1]) <= self.max_accuracy and epoch > 6)):
                    self.patience_ctr  = -1
                    self.learning_rate = self.learning_rate * 0.1
                    self.optimizer._lr = self.learning_rate
                    self.network.set_weights(self.weight_dict[max(self.weight_dict.keys())])
                    self.max_accuracy = max(self.val_acc)
                    self.network.save_weights(self.checkPointPath + '/' + str(epoch).format(epoch=epoch))
            if(epoch == 3):
                self.max_accuracy = max(self.val_acc)
            self.patience_ctr += 1

            if self.learning_rate < 1e-6:
                self.network.set_weights(self.weight_dict[max(self.weight_dict.keys())])
                self.network.save_weights(self.checkPointPath + '/' + str(epoch).format(epoch=epoch))
                break
        #########################Testing Dataset #################
        counter = 0
        for images, labels in val_generator.flow(self.test_images, self.test_labels, batch_size=self.batch_size, shuffle=True):
            acc = (self.test_validate(images, labels, 'validate'))
            counter += 1
            if (counter == len(self.test_images) / self.batch_size):
                #######Calculate intersection over union for each segmentation class####################
                y_pred = self.y_pred
                y_predi = np.argmax(y_pred, axis=3)
                y_testi = np.argmax(self.test_labels, axis=3)
                print('Shape of Predicted Image_label and Test Image_label', y_testi.shape, y_predi.shape)
                self.IoU(y_testi, y_predi)
                n_classes = 21
                # Visualizing the model Performance
                for i in range(21):
                    img_is = (self.test_images[i] + 1) * (255.0 / 2)
                    seg = y_predi[i]
                    segtest = y_testi[i]

                    fig = plt.figure(figsize=(10, 30))
                    ax = fig.add_subplot(1, 3, 1)
                    ax.imshow(img_is / 255.0)
                    ax.set_title("original")

                    ax = fig.add_subplot(1, 3, 2)
                    ax.imshow(give_color_to_seg_img(seg, n_classes))
                    ax.set_title("predicted class")

                    ax = fig.add_subplot(1, 3, 3)
                    ax.imshow(give_color_to_seg_img(segtest, n_classes))
                    ax.set_title("true class")
                    plt.show()
                break

        ###################################Plots########################
        fig, axes = plt.subplots(2, sharex=True, figsize=(12, 8))
        fig.suptitle('Training Metrics')

        axes[0].set_ylabel("Loss", fontsize=14)
        axes[0].plot(self.train_loss_his)

        axes[1].set_ylabel("Accuracy", fontsize=14)
        axes[1].set_xlabel("Epoch", fontsize=14)
        axes[1].plot(self.train_acc_his)
        plt.show()


        #######Calculate intersection over union for each segmentation class####################

        y_test = self.val_labels
        y_predi = np.argmax(y_pred, axis=3)
        y_testi = np.argmax(y_test, axis=3)
        print('Shape of Predicted Image_label and Test Image_label', y_testi.shape, y_predi.shape)
        self.IoU(y_testi, y_predi)


    def __init__(self, dataset_type):
        # if type == "MNIST":
        #batchSize = 128
        # ob = dataset(dataset_type, batchSize)
        # self.train_dataset, self.test_dataset, self.val_dataset = ob.train_dataset, ob.test_dataset, ob.val_dataset
        # voc2012 = VOC2012('C:/Users/rashi/PycharmProjects/Research1/datasets/VOC2012/')
        voc2012 = VOC2012('./datasets//VOC2012/')
        #voc2012.read_all_data_and_save()
        # voc2012.load_all_data()
        voc2012.load_all_data()
        # obj1=FCN()
        # # for i in range(0, voc2012.train_images.shape[0]):
        self.train_labels = voc2012.train_labels
        self.train_images = voc2012.train_images
        self.val_images = voc2012.val_images
        self.val_labels = voc2012.val_labels
        # self.test_images = voc2012.val_images
        # self.test_labels = voc2012.val_labels
        # train_images = np.array(voc2012.train_images.value, dtype= np.float32)
        # # obj1.call(train_images)

        self.y_predi=[]
        self.network = FCN()
        self.learning_rate = 0.0001
        self.momentum = 0.9
        self.batch_size = 10
        self.train_acc_his = []
        self.train_loss_his = []
        self.test_accuracy_his = []
        self.optimizer = tf.keras.optimizers.Adam(self.learning_rate, self.momentum)
        self.checkPointPath = os.path.dirname("./models/cp-{epoch:04d}.ckpt")
        self.val_acc = []
        self.weight_dict = {}
        self.patience_ctr = 0
        self.max_accuracy = 0
        self.train()

dataset_type = "MNIST"
main(dataset_type)
