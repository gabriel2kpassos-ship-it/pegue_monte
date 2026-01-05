# 🧩 Pegue e Monte

Sistema de **gestão de aluguéis de kits e produtos** desenvolvido em **Flutter**, com backend em **Firebase**.
O projeto atende um negócio real do modelo *Pegue e Monte*, permitindo controle de clientes, produtos, kits e aluguéis, com suporte a **Web** e **Android**.

---

## 🚀 Tecnologias Utilizadas

* **Flutter** (Web & Android)
* **Firebase**

  * Firestore (Banco de dados)
  * Firebase Auth
  * Firebase Hosting (Web)
* **Dart**

---

## 📂 Estrutura do Projeto

```text
lib/
 ├── firebase_options.dart
 ├── main.dart
 │
 ├── core/
 │   ├── services/
 │   │   ├── aluguel_service.dart
 │   │   ├── auth_service.dart
 │   │   ├── cliente_service.dart
 │   │   ├── kit_service.dart
 │   │   └── produto_service.dart
 │   │
 │   ├── theme/
 │   │   └── app_theme.dart
 │   │
 │   └── utils/
 │       ├── phone_display_formatter.dart
 │       └── phone_input_formatter.dart
 │
 ├── models/
 │   ├── aluguel_model.dart
 │   ├── cliente_model.dart
 │   ├── kit_model.dart
 │   ├── kit_item_model.dart
 │   └── produto_model.dart
 │
 └── modules/
     ├── dashboard/
     │   └── dashboard_page.dart
     │
     ├── login/
     │   └── login_page.dart
     │
     ├── clientes/
     │   ├── clientes_controller.dart
     │   ├── clientes_page.dart
     │   └── cliente_form_page.dart
     │
     ├── produtos/
     │   ├── produtos_controller.dart
     │   ├── produtos_page.dart
     │   └── produto_form_page.dart
     │
     ├── kits/
     │   ├── kits_controller.dart
     │   ├── kits_page.dart
     │   └── kit_form_page.dart
     │
     └── alugueis/
         ├── alugueis_controller.dart
         ├── alugueis_page.dart
         └── aluguel_form_page.dart
```

---

## 🧠 Arquitetura

O projeto segue uma arquitetura **feature-first**, com clara separação de responsabilidades:

* **Modules** → telas e controllers por funcionalidade
* **Models** → entidades do domínio
* **Services** → regras de negócio e integração com Firebase
* **Core** → código reutilizável (tema, utils, serviços globais)

📌 A UI fica desacoplada da lógica de negócio, facilitando manutenção e escalabilidade.

---

## 📦 Funcionalidades

* 🔐 Autenticação de usuários
* 👥 Cadastro e gerenciamento de clientes
* 📦 Cadastro de produtos
* 🧩 Criação de kits com múltiplos produtos
* 📆 Controle de aluguéis
* 📊 Dashboard com visão geral
* 📱 Formatação automática de telefone

---

## 🌐 Plataformas

* ✅ **Web** (Firebase Hosting)
* ✅ **Android (APK)**

---

## 👨‍💻 Autor

**Gabriel Silva Passos**
Desenvolvedor Flutter

🔗 GitHub: [https://github.com/gabriel2kpassos-ship-it](https://github.com/gabriel2kpassos-ship-it)

---

## 📄 Licença

Este projeto está sob a licença MIT.

---
