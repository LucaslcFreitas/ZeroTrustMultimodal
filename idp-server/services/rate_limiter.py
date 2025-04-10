from datetime import datetime, timedelta, timezone
from collections import defaultdict

class RateLimiter:
    def __init__(self):
        self.request_log = defaultdict(list)
        self.limits = {
            'authenticate': (10, timedelta(minutes=1)),
            'reauthenticate': (5, timedelta(minutes=1)),
            'logout': (10, timedelta(hours=1))
        }

    def check_limit(self, client_id: str, endpoint: str, time: str):
        limit, time_window = self.limits.get(endpoint)

        now = datetime.strptime(time, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=timezone(timedelta(hours=-3)))
        
        self.request_log[client_id] = [
            req_time for req_time in self.request_log[client_id]
            if now - req_time < time_window
        ]
        
        if len(self.request_log[client_id]) >= limit:
            return False
        
        self.request_log[client_id].append(now)
        return True