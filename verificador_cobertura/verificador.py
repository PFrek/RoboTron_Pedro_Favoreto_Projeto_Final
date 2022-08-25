from robot.api.deco import keyword, library
import json

@library
class VerificadorCobertura:
    
    def __init__(self, json, caminho):
        self.operacoes = {}
        for op in json[caminho]:
            respostas = []
            respostas_json = op["respostas"]
            for resposta in respostas_json:
                respostas.append(Resposta(resposta["status_code"], resposta["body_params"]))
                
            self.operacoes[op["verbo"]] = Operacao(op["verbo"], op["header_params"], op["body_params"], respostas)
            
    
    @keyword
    def validar_caminho(self, caminho, verbo, status):
        pass
    


class Resposta:
    
    def __init__(self, status_code, body_params):
        self.status_code = {"code": status_code, "validado": False}

        self.body_params = {}
        for chave, valor in body_params.items():
            self.body_params[chave] = {"tipo": valor, "validado": False}
        
    
    def reset(self):
        self.status_code["validado"] = False
        for valor in self.body_params.values():
            valor["validado"] = False
            
    def validar_status_code(self):
        self.status_code["validado"] = True
        
    def validar_body_param(self, parametro):
        self.body_params[parametro]["validado"] = True
        
    def validar_tudo(self):
        self.validar_status_code()
        for parametro in self.body_params:
            self.validar_body_param(parametro)    
    
    def status_validado(self):
        return self.status_code["validado"]
    
    def cobertura(self):
        num_validacoes = len(self.body_params) + 1
        num_validados = 0
        
        if self.status_validado():
            num_validados += 1
        
        for parametro in self.body_params.values():
            if parametro["validado"]:
                num_validados += 1
                
        return num_validados / float(num_validacoes)
    
    def mostrar(self):
        print("Status Code:", self.status_code["code"], "/", self.status_validado())
        print("Parâmetros:", len(self.body_params))
        for chave, valor in self.body_params.items():
            print("\t", chave, ":", valor)
        print("Cobertura da resposta:", self.cobertura()*100, "%")
        

class Operacao:
    
    def __init__(self, verbo, header_params, body_params, respostas):
        self.verbo = {"verbo": verbo, "validado": False}
        
        self.header_params = {}
        for chave, valor in header_params.items():
            self.header_params[chave] = {"tipo": valor, "validado": False}

        self.body_params = {}
        for chave, valor in body_params.items():
            self.body_params[chave] = {"tipo": valor, "validado": False}
            
        self.respostas = {}
        for resposta in respostas:
            self.respostas[resposta.status_code["code"]] = resposta
    
    def reset(self):
        self.verbo["validado"] = False
        
        for valor in self.header_params.values():
            valor["validado"] = False
            
        for valor in self.body_params.values():
            valor["validado"] = False
            
        for resposta in self.respostas:
            resposta.reset()
    
    def validar_verbo(self):
        self.verbo["validado"] = True
        
    def validar_header_param(self, parametro):
        self.header_params[parametro]["validado"] = True
    
    def validar_body_param(self, parametro):
        self.body_params[parametro]["validado"] = True
    
    def validar_status_code_resposta(self, status_code):
        self.respostas[status_code].validar_status_code()
        
    def validar_body_param_resposta(self, status_code, parametro):
        self.respostas[status_code].validar_body_param(parametro)
    
    def validar_tudo_resposta(self, status_code):
        self.respostas[status_code].validar_tudo()
        
    def verbo_validado(self):
        return self.verbo["validado"]
    
    def cobertura(self):
        num_validacoes = len(self.body_params) + len(self.header_params) + len(self.respostas) + 1
        num_validados = 0
        
        if self.verbo_validado():
            num_validados += 1
            
        for parametro in self.header_params.values():
            if parametro["validado"]:
                num_validados += 1
        
        for parametro in self.body_params.values():
            if parametro["validado"]:
                num_validados += 1
                
        for resposta in self.respostas.values():
            num_validados += resposta.cobertura()
        
        return num_validados / float(num_validacoes)
    
    def mostrar(self):
        print("Verbo:", self.verbo["verbo"], "/", self.verbo_validado())
        
        print("Header_params:", len(self.header_params))
        for chave, valor in self.header_params.items():
            print("\t", chave, ":", valor)
        
        print("Body_params:", len(self.body_params))
        for chave, valor in self.body_params.items():
            print("\t", chave, ":", valor)
        
        print("Respostas:", len(self.respostas))
        for resposta in self.respostas.values():
            resposta.mostrar()
            
        print("Cobertura da operação:", self.cobertura()*100, "%")
            
    
        
    
    
def main():
    respostas = [
        Resposta(200, {"message": "string", "authorization": "string"}),
        Resposta(400, {"message": "string"})
    ]
    
    login_post = Operacao("post", {}, {"email": "string", "password": "string"}, respostas)
    login_post.validar_verbo()
    login_post.validar_body_param("email")
    login_post.validar_body_param("password")
    login_post.validar_tudo_resposta(200)
    # login_post.validar_tudo_resposta(400)
    login_post.mostrar()
    

if __name__ == "__main__":
    main()