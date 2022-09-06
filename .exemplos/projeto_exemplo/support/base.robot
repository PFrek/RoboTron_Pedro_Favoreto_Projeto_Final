# Sessão para configuração, documentação, imports de arquivos e libraries
* Settings *
Documentation        Arquivo simples para requisições HTTP em APIs REST
Library              RequestsLibrary
Library              Collections
Library              OperatingSystem
Library              FakerLibrary
Resource             ./common/common.robot
Resource             ./fixtures/dynamics.robot
Resource             ./variables/serverest_variaveis.robot

# Sessão para criação de Keywords Personalizadas
* Keywords *
Criar Sessao
    Create Session        serverest    ${BASE_URI}
