from robot.api.deco import library, keyword
import json

@library
class Gerador_Dados_Invalidos:
    
    def __init__(self):
        self.modelo = {}
        self.massa_de_dados = []
    
    @keyword
    def Definir_Modelo(self, modelo):
        self.modelo = modelo
        
    @keyword
    def Gerar_Massa_De_Dados_Invalidos(self):
        for chave, valor in self.modelo.items():
            if type(valor) == str:
                entrada_em_branco = self.modelo.copy()
                entrada_em_branco[chave] = ""
                self.massa_de_dados.append(entrada_em_branco)
            
            entrada_faltando = self.modelo.copy()
            del entrada_faltando[chave]
            self.massa_de_dados.append(entrada_faltando)
        
    
    @keyword
    def Obter_Massa_De_Dados_Invalidos(self):
        return self.massa_de_dados
    
        
        
if __name__ == '__main__':
    gerador = Gerador_Dados_Invalidos()
    modelo_jsn = json.loads('{ "name": "Teste", "idade": 12, "Bio": "Teste bio string" }')
    gerador.Definir_Modelo(modelo_jsn)
    gerador.Gerar_Massa_De_Dados_Invalidos()