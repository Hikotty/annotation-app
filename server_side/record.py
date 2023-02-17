def record(action):
    import session
    import csv
    from time import time

    if not session.get_current_session():
        session.chage_session()
        current_session = str(session.get_current_session())
    else:
        current_session = str(session.get_current_session())

    try:
        with open('./'+current_session,"r") as f:
            r = csv.reader(f)
            actions = []
            for i in r:
                actions.append(i)

            if actions[-1][0] != action:
                now = int(time())
                actions.append([actions[-1][0],str(now)])
                actions.append([action,str(now+1)])
                with open('./'+current_session,"w") as f:
                    writer = csv.writer(f)
                    writer.writerows(actions)

    except:
        with open('./'+current_session,"w") as f:
            writer = csv.writer(f)
            writer.writerow([action,str(int(time()))])

def stop_action():
    import session
    import csv
    from time import time

    try:
        current_session = session.get_current_session()
    except:
        return -1
    current_session = str(current_session)

    try:
        with open('./'+current_session,"r") as f:
            r = csv.reader(f)
            actions = []
            for i in r:
                actions.append(i)

            now = int(time())
            actions.append([actions[-1][0],str(now)])
            with open('./'+current_session,"w") as f:
                writer = csv.writer(f)
                writer.writerows(actions)

    except:
        return -1
