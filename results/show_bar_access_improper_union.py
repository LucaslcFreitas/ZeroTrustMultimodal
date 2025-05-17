import numpy as np
import matplotlib.pyplot as plt

def showBar():
    data = {
        "Teste 1": {
            "Medico": {"Permitido": 5, "Negado": 117, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 18},
            "Enfermeiro": {"Permitido": 8, "Negado": 108, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 24},
            "Atendente": {"Permitido": 0, "Negado": 105, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 35},
            "Administrador": {"Permitido": 5, "Negado": 117, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 18},
            "Paciente": {"Permitido": 6, "Negado": 114, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 20},
        },
        "Teste 2": {
            "Medico": {"Permitido": 0, "Negado": 135, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 5},
            "Enfermeiro": {"Permitido": 0, "Negado": 124, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 16},
            "Atendente": {"Permitido": 0, "Negado": 111, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 29},
            "Administrador": {"Permitido": 0, "Negado": 121, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 19},
            "Paciente": {"Permitido": 0, "Negado": 129, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 11},
        },
        "Teste 3": {
            "Medico": {"Permitido": 0, "Negado": 129, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 11},
            "Enfermeiro": {"Permitido": 0, "Negado": 125, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 15},
            "Atendente": {"Permitido": 0, "Negado": 118, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 22},
            "Administrador": {"Permitido": 0, "Negado": 130, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 10},
            "Paciente": {"Permitido": 0, "Negado": 128, "Permitido por reautenticacao": 0, "Negado por reautenticacao": 12},
        }
    }

    colors = {
        'Permitido': '#005900',
        'Permitido por reautenticacao': '#0000cc', 
        'Negado': '#cc0000', 
        'Negado por reautenticacao': '#e89275',
    }

    categories = list(colors.keys())
    user_types = list(data["Teste 1"].keys())
    tests = list(data.keys())
    
    bar_width = 0.1
    space_between_user_groups = 0.3
    space_between_tests = 0.05
    
    fig, ax = plt.subplots(figsize=(15, 6))
    
    max_bar_value = max([max(data[test][user].values()) for test in tests for user in user_types])
    
    for user_idx, user in enumerate(user_types):
        user_group_pos = user_idx * (len(tests) * len(categories) * bar_width + 
                                   (len(tests)-1)*space_between_tests + 
                                   space_between_user_groups)
        
        for test_idx, test in enumerate(tests):
            test_pos = user_group_pos + test_idx * (len(categories) * bar_width + space_between_tests)
            
            for cat_idx, category in enumerate(categories):
                pos = test_pos + cat_idx * bar_width
                value = data[test][user].get(category, 0)
                ax.bar(pos, value, bar_width, color=colors[category], 
                       label=category if user_idx == 0 and test_idx == 0 else "",
                       edgecolor='white', linewidth=0.5)
                
                ax.text(pos, value + max_bar_value*0.01, f"{value}", 
                       ha='center', va='bottom', fontsize=8)

    first_bar_pos = 0
    last_bar_pos = (len(user_types)-1) * (len(tests) * len(categories) * bar_width + 
                                        (len(tests)-1)*space_between_tests + 
                                        space_between_user_groups) + \
                  len(tests) * len(categories) * bar_width
    
    ax.set_xlim(first_bar_pos - bar_width, last_bar_pos + bar_width)
    
    user_label_positions = [i * (len(tests) * len(categories) * bar_width + 
                          (len(tests)-1)*space_between_tests + 
                          space_between_user_groups) + 
                         (len(tests) * len(categories) * bar_width)/2 
                         for i in range(len(user_types))]
    
    ax.set_xticks(user_label_positions)
    ax.set_xticklabels(user_types, fontsize=12)
    
    label_y_position = -max_bar_value * 0.08
    for user_idx in range(len(user_types)):
        user_group_pos = user_idx * (len(tests) * len(categories) * bar_width + 
                        (len(tests)-1)*space_between_tests + 
                        space_between_user_groups)
        for test_idx, test in enumerate(tests):
            test_pos = user_group_pos + test_idx * (len(categories) * bar_width + space_between_tests)
            label_pos = test_pos + (len(categories) * bar_width)/2
            ax.text(label_pos, label_y_position, test, 
                   ha='center', va='top', fontsize=10)

    # Linhas divisórias
    for i in range(1, len(user_types)):
        divider_pos = i * (len(tests) * len(categories) * bar_width + 
                         (len(tests)-1)*space_between_tests + 
                         space_between_user_groups) - space_between_user_groups/2
        ax.axvline(x=divider_pos, color='gray', linestyle='--', linewidth=1, alpha=0.7)
    
    # Configuração do eixo Y
    ax.set_ylim(0, max_bar_value * 1.1)
    y_ticks = np.linspace(0, max_bar_value * 1.1, num=6)
    ax.set_yticks(y_ticks)
    ax.set_yticklabels([f"{int(y)}" for y in y_ticks])
    
    # Elementos do gráfico
    ax.set_ylabel('Quantidade', fontsize=12)
    
    handles, labels = ax.get_legend_handles_labels()
    ax.legend(handles[:len(categories)], labels[:len(categories)], 
              loc='upper center', bbox_to_anchor=(0.5, -0.15),
              ncol=len(categories), frameon=False)
    
    for spine in ['top', 'right']:
        ax.spines[spine].set_visible(False)
    ax.grid(axis='y', linestyle=':', alpha=0.4)
    
    plt.tight_layout()
    plt.subplots_adjust(bottom=0.2)
    plt.show()

if __name__ == '__main__':
    showBar()