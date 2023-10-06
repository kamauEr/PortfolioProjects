#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# simple file sorter for commonly used files in your PC
# Sorts the files in folders according to the file format, You can add or remove depending on the files you want to organize


# In[15]:


import os, shutil


# In[ ]:


# add path name eg path = r"C:/Users/Willlie/Desktop/ROSE/"


# In[16]:


path = r"your path name"


# In[17]:


file_name = os.listdir(path)


# In[18]:


folder_names = ['csv_files','image_files','text_files']
for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
        os.makedirs((path + folder_names[loop]))


# In[ ]:


# Commonly used files in the download files on a Computer system


# In[22]:


for file in file_name:
    if ".pdf" in file and not os.path.exists(path + 'csv_files/' + file):
            shutil.move(path+ file, path + "csv_files/" + file)
    elif ".docx"  in file and not os.path.exists(path + 'text_files/' + file):
            shutil.move(path+ file, path + "text_files/" + file)
    elif ".zip"  in file and not os.path.exists(path + 'image_files/' + file):
            shutil.move(path+ file, path + "image_files/" + file)
    elif ".mp4"  in file and not os.path.exists(path + 'mp4_files/' + file):
            shutil.move(path+ file, path + "mp4_files/" + file)
    elif ".png"  in file and not os.path.exists(path + 'png_files/' + file):
            shutil.move(path+ file, path + "png_files/" + file)
    elif ".rar"  in file and not os.path.exists(path + 'rar_files/' + file):
            shutil.move(path+ file, path + "rar_files/" + file)
    elif ".txt"  in file and not os.path.exists(path + 'txt_files/' + file):
            shutil.move(path+ file, path + "txt_files/" + file)
    elif ".mp3"  in file and not os.path.exists(path + 'mp3_files/' + file):
            shutil.move(path+ file, path + "mp3_files/" + file)
    # add ppt or pptx depending on the file format for a Microsoft PowerPoint format
    elif ".ppt"  in file and not os.path.exists(path + 'ppt_files/' + file):
            shutil.move(path+ file, path + "ppt_files/" + file)

