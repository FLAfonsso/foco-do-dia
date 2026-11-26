# 🎯 Foco do Dia

Aplicativo de **tarefas diárias** desenvolvido em **Flutter** para a disciplina de **Desenvolvimento para Dispositivos Móveis** (Uniube).

O usuário se cadastra, faz login, escolhe um dia no calendário e organiza as tarefas daquele dia: adiciona, marca como concluída e remove.

---

## ✨ Funcionalidades

- **Cadastro e login** com validação de campos (e-mail, senha com no mínimo 6 caracteres, confirmação de senha)
- **Calendário** em português, com destaque no dia selecionado e marcadores nos dias que têm tarefas
- **Lista de tarefas por dia**, com contador de pendentes e concluídas e barra de progresso
- **Adicionar tarefa** por meio de um `showDialog`
- **Marcar como concluída** pelo checkbox (a tarefa fica riscada)
- **Remover tarefa** pela lixeira ou arrastando o item para o lado
- **Ordenação automática**: tarefas **pendentes primeiro**, depois as **concluídas**, ambas em **ordem alfabética**
- Toda tarefa nova começa como **não concluída**

## 🎨 Design

Paleta **azul-petróleo** com **amarelo vibrante**, com cards arredondados, círculos decorativos no cabeçalho e fundo creme nas áreas de conteúdo.

| Cor | Hex | Uso |
|---|---|---|
| Azul-petróleo escuro | `#052F40` | Fundo das telas |
| Azul-petróleo | `#0B4F6C` | Cards, contadores, checkbox |
| Amarelo vibrante | `#FFD60A` | Botões, destaques, dia selecionado |
| Creme | `#FFF8E1` | Áreas de conteúdo |

## 🧱 Arquitetura

O projeto separa **interface**, **lógica** e **dados**:

```
lib/
├── main.dart                    # Ponto de entrada: tema, Providers e tela inicial
├── models/
│   ├── usuario.dart             # Modelo do usuário (nome, e-mail, senha)
│   └── tarefa.dart              # Modelo da tarefa (título, data, concluída)
├── services/
│   ├── auth_service.dart        # Cadastro, login e logout
│   └── tarefa_service.dart      # Adicionar, remover, concluir e ordenar tarefas
├── screens/
│   ├── login_screen.dart
│   ├── cadastro_screen.dart
│   ├── calendario_screen.dart
│   └── tarefas_screen.dart
├── widgets/
│   ├── botao_principal.dart     # Botão amarelo reutilizável
│   ├── cabecalho_auth.dart      # Cabeçalho decorado das telas de login/cadastro
│   ├── tarefa_item.dart         # Item da lista (checkbox, status, lixeira)
│   └── nova_tarefa_dialog.dart  # Dialog para adicionar tarefa
└── theme/
    └── app_theme.dart           # Cores e estilos globais

test/
└── foco_do_dia_test.dart        # Testes de lógica e de fluxo completo
```

- **Gerenciamento de estado:** `Provider` com `ChangeNotifier`. Quando uma tarefa muda, as telas são atualizadas automaticamente.
- **Armazenamento:** em memória, com as tarefas organizadas em um `Map` cuja chave é a data do dia. O enunciado da atividade dispensa o Firebase.

## 📦 Pacotes utilizados

| Pacote | Para quê |
|---|---|
| [`provider`](https://pub.dev/packages/provider) | Gerenciamento de estado |
| [`table_calendar`](https://pub.dev/packages/table_calendar) | Widget de calendário |
| [`intl`](https://pub.dev/packages/intl) | Datas formatadas em português |

## ▶️ Como executar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) e um emulador Android (ou o Windows como dispositivo).

```bash
flutter create foco_do_dia
cd foco_do_dia
flutter pub add provider table_calendar intl
# substitua a pasta lib/ (e test/) pelas deste repositório
flutter run
```

## ✅ Testes

O projeto tem **15 testes automatizados**: testes de lógica (ordenação, status inicial, separação por dia, remoção, validações de cadastro e login) e um teste que simula o uso completo do app (cadastro → login → calendário → adicionar, concluir e remover).

```bash
flutter test
```

Resultado: `All tests passed!`

---

Desenvolvido por **Pedro** · Uniube · 2026
