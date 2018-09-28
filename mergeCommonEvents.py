from os import listdir


path = 'Data/CommonEvents/'
files = listdir(path)
files.sort()

with open('Data/CommonEvents.json', 'w') as outfile:
    outfile.write('[\n  null,\n')
    for ffile in files:
        with open(path + ffile) as infile:
            data = infile.read()
            outfile.write(data)
    outfile.write('\n]')

