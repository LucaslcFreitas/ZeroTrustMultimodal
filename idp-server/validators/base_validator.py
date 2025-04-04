


class BaseValidator:
    REQUIRED_FIELDS = []
    
    def validate(self, data):
        missing_fields = [field for field in self.REQUIRED_FIELDS if field not in data]
        if missing_fields:
            return False, f"Missing required fields: {', '.join(missing_fields)}"
        return True, None