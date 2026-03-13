📱 App de Comandas para Garçons

<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Code-Clean-purple?style=for-the-badge" alt="Clean Code">
<img src="https://img.shields.io/badge/Tests-Unit-green?style=for-the-badge" alt="Unit Tests">
</div>

⚠️ Projeto de Portfólio | Repositório do aplicativo mobile (Flutter) para o sistema de gerenciamento de comandas de restaurantes. Este app é a ferramenta do garçom para lançar pedidos, gerenciar mesas e fechar contas de forma rápida e eficiente.

Status do Projeto

O projeto está em desenvolvimento ativo. A funcionalidade de autenticação está 100% funcional, comunicando-se com a API dedicada para validar as credenciais do garçom.

🎯 Sobre o Projeto

Este projeto visa modernizar o atendimento em restaurantes, substituindo o tradicional bloco de papel por um aplicativo ágil. O garçom pode fazer login e, futuramente, visualizar o mapa de mesas, lançar pedidos diretamente para a cozinha e solicitar o fechamento da conta.

Este repositório contém exclusivamente o projeto mobile (Frontend).

🔗 Projeto da API (Backend)

O backend deste sistema (API RESTful) foi desenvolvido em Java com Spring Boot e pode ser encontrado em outro repositório.

Link da API: https://github.com/BrunoAlexys/api-comanda.git

✨ Funcionalidades Atuais

✅ Tela de Login: Interface de usuário limpa e responsiva.

✅ Autenticação: Validação de credenciais de usuário (email/senha) via integração com a API Spring Boot.

✅ Gerenciamento de Estado: Controle do estado de autenticação (loading, sucesso, erro).

🗺️ Roadmap (Próximos Passos)

▶️ Lançamento de Pedidos: Seleção de itens do cardápio e envio para a cozinha.

▶️ Gerenciamento de Comanda: Adicionar, remover ou editar itens de uma comanda.

▶️ Fechamento de Conta: Solicitação de fechamento e divisão da conta.

🖼️ Telas do App

Tela de Login

![WhatsApp Image 2025-10-27 at 14 09 30](https://github.com/user-attachments/assets/a9160879-8f5f-4471-b27d-882111f8f633)

🛠️ Stack Tecnológica

Este projeto foi construído utilizando um stack moderno e robusto, tanto no mobile quanto no backend.

Mobile (Este Repositório)

Flutter: Framework principal para desenvolvimento nativo e performático em iOS e Android.

Dart: Linguagem de programação moderna e otimizada para UI.

MobX: Gerenciador de estado para manter a UI reativa e o código organizado.

Dio: Cliente HTTP para comunicação com a API RESTful.

Mockito / test: Ferramentas para a criação de testes unitários e de widget.

Backend & Infraestrutura (API Associada)

Java 21: Linguagem robusta e amplamente utilizada no mercado para o backend.

Spring Boot: Framework para criação de APIs RESTful de forma rápida e segura.

Spring Security: Utilizado para gerenciar a autenticação e autorização (ex: JWT).

PostgreSQL: Banco de dados relacional para persistência dos dados.

Docker: Usado para criar containers da aplicação e do banco de dados, garantindo um ambiente de desenvolvimento e produção consistente.

🏛️ Arquitetura e Conceitos Aplicados

Este não é apenas um projeto focado em "fazer funcionar", mas em "fazer do jeito certo". Aplicamos conceitos de engenharia de software para garantir que o app seja escalável, testável e de fácil manutenção.

MVC: A lógica de negócios é separada da UI e da fonte de dados, facilitando testes e manutenibilidade.

Gerenciamento de Estado Reativo: Usando MobX, a UI reage automaticamente às mudanças nos dados (como o status de login).

Injeção de Dependência (DI): Facilitando a troca de implementações e, principalmente, a criação de mocks em testes.

🧪 Qualidade e Testes

A qualidade do código é uma prioridade. O projeto conta com uma suíte de testes para garantir que as regras de negócio e os componentes da UI funcionem como esperado.

Testes Unitários

Validamos os Controllers, Blocs ou UseCases de forma isolada. Por exemplo, testamos o fluxo de login para garantir que os estados corretos (loading, sucesso, erro) sejam emitidos em cada cenário.

🚀 Como Executar o Projeto

Pré-requisitos:

Ter a API do Backend rodando localmente (ou em um servidor).

Ter o Flutter SDK na versão 3.35.1 instalado.

Clone o repositório:

git clone https://github.com/BrunoAlexys/mobile-comanda.git

Instale as dependências:

flutter pub get

Configure o IP da API:

(Recomendado) Crie um arquivo .env na raiz do projeto.

Adicione a variável de ambiente da sua API BASE_URL=http://SEU_IP_LOCAL:8080/api

Lembre-se: se estiver rodando no emulador Android, seu IP local geralmente é 10.0.2.2.

Execute o app:

flutter run


👨‍💻 Autores

Este projeto é mantido por dois desenvolvedores como parte de nosso portfólio. Sinta-se à vontade para entrar em contato!

<table align="center" border="0" cellpadding="10" cellspacing="0" style="border: none !important;">
<tr style="border: none !important;">
<td align="center" style="border: none !important;">
<a href="https://github.com/BrunoAlexys">
<img src="https://github.com/BrunoAlexys.png" width="100px;" alt="Foto do Bruno Alexys"/>
<br />
<sub><b>Bruno Álexys</b></sub>
</a>
<br />
<a href="https://www.linkedin.com/in/bruno-alexys-moura/">LinkedIn</a> |
<a href="https://github.com/BrunoAlexys">GitHub</a>
</td>
<td align="center" style="border: none !important;">
<a href="https://github.com/BrenoMoura00">
<img src="https://github.com/BrenoMoura00.png" width="100px;" alt="Foto de Breno Moura"/>
<br />
<sub><b>Breno Moura</b></sub>
</a>
<br />
<a href="https://www.linkedin.com/in/breno-moura-silva/">LinkedIn</a> |
<a href="https://github.com/BrenoMoura00">GitHub</a>
</td>
</tr>
</table>
