* Settings *
Documentation        Arquivo base para centralização de imports e resources.
Library              RequestsLibrary
Resource             ./common/common.robot
Resource             ./fixtures/dynamics.robot
Resource             ./variables/serverest_variaveis.robot

# Sessão para criação de Keywords Personalizadas
* Keywords *
Criar Sessao
    Create Session        serverest    ${BASE_URI}
