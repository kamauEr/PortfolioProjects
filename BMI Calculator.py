#!/usr/bin/env python
# coding: utf-8

# In[28]:


name  = input("Please enter your name: ")
weight = float(input("Please enter your Weight in Kilograms: "))
height = float(input("Please enter your Height in meters: "))

bmi = weight / (height * height)
if bmi > 0:
    if bmi<18.5:
        print(name +  ", You are UnderWeight - Eat more!")
    elif bmi < 24.9:
        print(name + ", You are Healthy - Keep Exercising!")
    elif bmi < 29.9:
            print(name +", You are Overweight - Keep fit!")
    elif bmi < 34.9:
        print(name + ", You are Obese - Start Exercising!")
    elif bmi < 39.9:
        print(name + ", You are Severly Obese - See a Doctor!")
    elif bmi > 40:
        print(name + ", You are Morbidly Obese - See a Doctor!")
        
else: print("Please Enter the correct Values!")
    
        


# In[ ]:




