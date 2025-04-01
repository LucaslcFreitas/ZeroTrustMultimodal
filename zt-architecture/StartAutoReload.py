from watchdog.observers.polling import PollingObserver
from watchdog.events import FileSystemEventHandler
import subprocess
import time
import os
import signal

class RestartOnChange(FileSystemEventHandler):
    def __init__(self, command):
        self.command = command
        self.process = None
        self.start_process()

    def start_process(self):
        self.process = subprocess.Popen(self.command, shell=True, preexec_fn=os.setsid)

    def restart(self):
        if self.process:
            os.killpg(os.getpgid(self.process.pid), signal.SIGTERM)
        self.start_process()

    def on_modified(self, event):
        if event.src_path.endswith(".py"):
            self.restart()

if __name__ == "__main__":
    path = os.getcwd()
    command = "python PolicyEnforcementPoint.py"
    event_handler = RestartOnChange(command)
    observer = PollingObserver()
    observer.schedule(event_handler, path, recursive=True)
    observer.start()
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        if event_handler.process:
            os.killpg(os.getpgid(event_handler.process.pid), signal.SIGTERM)
    observer.join()
