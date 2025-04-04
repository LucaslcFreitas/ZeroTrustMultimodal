class SignalValidator:
    
    def validate_signals(self, ppg_signal, ecg_signal):
        errors = []
        
        # Validação PPG
        ppg_result = self._validate_ppg(ppg_signal)
        if not ppg_result['valid']:
            errors.append(ppg_result['error'])
            
        # Validação ECG
        ecg_result = self._validate_ecg(ecg_signal)
        if not ecg_result['valid']:
            errors.append(ecg_result['error'])
            
        return {
            'valid': len(errors) == 0,
            'errors': errors if errors else None,
            'details': {
                'ppg': ppg_result,
                'ecg': ecg_result
            }
        }
    
    def _validate_ppg(self, signal):
        # Implementação detalhada
        return {
            'valid': True
        }

    def _validate_ecg(self, signal):
        # Implementação detalhada
        return {
            'valid': True
        }