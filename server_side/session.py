def chage_session():
    import json
    
    try:
        with open("./server_side/session.txt", 'r') as file:
            session_list = json.load(file)
    except:
        session_list = []

    if len(session_list) == 0:
        session_list.append({
            'sessionID':1,
            'filename':'session1.csv',
        })
        with open("./server_side/session.txt", 'w') as file:
            json.dump(session_list, file, indent=2)
        return 1

    current_session = session_list[-1]["sessionID"]
    filename = "session" + str(current_session+1) + ".csv"

    session_list.append({
            'sessionID':current_session+1,
            'filename':filename
        })
    with open("./server_side/session.txt", 'w') as file:
        json.dump(session_list, file, indent=2)
    
    return 1

def get_current_session():
    import json

    try:
        with open("./server_side/session.txt", 'r') as file:
            session_list = json.load(file)
    except:
        chage_session()
        return 1

    return session_list[-1]["filename"]