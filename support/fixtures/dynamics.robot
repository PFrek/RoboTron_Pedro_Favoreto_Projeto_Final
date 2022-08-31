* Settings *
Documentation        Keywords para geração de dados dinâmicos.
Library              FakerLibrary
Library              ../../Gerador_Dados_Invalidos.py

* Keywords *

Criar Dados Usuario Dinamico
    [Documentation]               Cria um dicionário contendo os dados de um usuário dinâmico.
    ...                           \nReturn: \&{dados_usuario} -- os dados do usuário gerado.
    [Arguments]                   ${administrador}=true
    
    ${nome}                       FakerLibrary.Name
    ${email}                      FakerLibrary.Email
    ${password}                   FakerLibrary.Password

    &{dados_usuario}              Create Dictionary
    ...                           nome=${nome}    
    ...                           email=${email}
    ...                           password=${password}    
    ...                           administrador=${administrador}

    [Return]                      &{dados_usuario}

    
Criar Dados Produto Dinamico
    [Documentation]               Cria um dicionário contendo os dados de um produto dinâmico.
    ...                           \nReturn: \&{dados_produto} -- os dados do produto gerado.
    [Arguments]                   ${quantidade}=${100}

    ${nome}                       FakerLibrary.Sentence      nb_words=4
    ${preco}                      FakerLibrary.Random Int    min=1    max=9999
    ${descricao}                  FakerLibrary.Sentence      nb_words=10
    &{dados_produto}              Create Dictionary    
    ...                           nome=${nome}    
    ...                           preco=${preco}
    ...                           descricao=${descricao}    
    ...                           quantidade=${quantidade}
    
    [Return]                      &{dados_produto}

Gerar Dados Invalidos
    [Documentation]         Utiliza o Gerador para obter uma lista contendo
    ...                     permutações de dados inválidos criadas a partir de um
    ...                     modelo válido.
    ...                     \nTest Variable criada: \@{dados_invalidos} -- a lista de dados inválidos gerados.
    [Arguments]             ${modelo}
    
    Definir Modelo          ${modelo}
    
    Gerar Massa De Dados Invalidos
    @{dados_invalidos}      Obter Massa De Dados Invalidos
    
    [Return]                ${dados_invalidos}