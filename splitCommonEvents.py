
with open('Data/CommonEvents.json') as infile:
    data = infile.read()
    events = data.split('  },\n  {')
    count = 1
    for event in events:
        filename = str(count).zfill(3)
        filename += '.json'
        if count == 1:
            event = event[event.find('\n') + 1:]
            event = event[event.find('\n') + 1:]
        event = event[event.find('\n') + 1:]
        with open('Data/CommonEvents/' + filename, 'w') as outfile:
            outfile.write('  {\n')
            if count == len(events):
                event = event[0:event.rfind('\n')]
                outfile.write(event)
            else:
                outfile.write(event)
                outfile.write('  },\n')
        count += 1

