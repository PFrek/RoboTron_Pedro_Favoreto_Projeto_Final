import tkinter as tk

root = tk.Tk()
root.geometry("200x150")
frame = tk.Frame(root, bd = 5, bg = "purple")
frame.pack()

leftframe = tk.Frame(root, bg = "blue", bd = 3)
leftframe.pack(side=tk.LEFT)

rightframe = tk.Frame(root, bg = "red", bd = 3)
rightframe.pack(side=tk.RIGHT)

label = tk.Label(frame, text = "Hello world")
label.pack()

button1 = tk.Button(leftframe, text = "Button1")
button1.pack(padx = 3, pady = 3)
button2 = tk.Button(rightframe, text = "Button2")
button2.pack(padx = 3, pady = 3)
button3 = tk.Button(leftframe, text = "Button3")
button3.pack(padx = 3, pady = 3)

root.title("Test")
root.mainloop()