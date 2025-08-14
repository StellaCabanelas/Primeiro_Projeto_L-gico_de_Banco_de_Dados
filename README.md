# 📦 Sistema de Gerenciamento de Vendas (SQL)

Este projeto apresenta a modelagem e implementação de um banco de dados relacional para gerenciamento de vendas, clientes, pagamentos e entregas.  
Ele foi desenvolvido com foco em boas práticas de modelagem, uso correto de JOINs e constraints para garantir integridade referencial.

---

## 📑 Funcionalidades

- Cadastro de clientes (**Pessoa Física** ou **Jurídica**, com restrição para não ter os dois tipos simultaneamente).
- Registro de pedidos, pagamentos (com possibilidade de múltiplas formas por pedido) e entregas (com status e código de rastreio).
- Relacionamentos implementados com constraints como `ON DELETE CASCADE` e `ON UPDATE CASCADE`.
- Consultas com diferentes tipos de JOIN (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`).

---

## 🗂 Estrutura do Banco de Dados

O banco contém as seguintes tabelas principais:

- **clientes** — Armazena dados de clientes (PF ou PJ).
- **pedidos** — Registra informações sobre cada pedido.
- **pagamentos** — Controla as formas de pagamento e vincula ao pedido.
- **entregas** — Guarda status e código de rastreio.

O diagrama relacional foi modelado garantindo normalização e integridade dos dados.

---

## 🛠 Tecnologias Utilizadas

- **PostgreSQL** (compatível com MySQL e outros SGBDs com pequenas adaptações)
- **SQL DDL** (Data Definition Language) para criação de tabelas e constraints
- **SQL DML** (Data Manipulation Language) para inserção e consultas
