//
//  IndicaAmigoViewController.swift
//  Hinova_challenge
//
//  Created by Henrique Valadares on 11/06/18.
//  Copyright © 2018 Henrique Valadares. All rights reserved.
//

import UIKit

class IndicaAmigoViewController : UIViewController , UITextFieldDelegate
{
    
    @IBOutlet weak var codigoAssociacao: UITextField!
    @IBOutlet weak var cpfAssociado: UITextField!
    @IBOutlet weak var emailAssociado: UITextField!
    @IBOutlet weak var telefoneAssociado: UITextField!
    @IBOutlet weak var placaVeiculoAssociado: UITextField!
    @IBOutlet weak var nomeAmigo: UITextField!
    @IBOutlet weak var telefoneAmigo: UITextField!
    @IBOutlet weak var emailAmigo: UITextField!
    @IBOutlet weak var emailRemetente: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var enviar: UIButton!
    @IBOutlet weak var nomeAssociado: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Indica Amigo"
        self.codigoAssociacao.delegate = self;
        self.cpfAssociado.delegate = self;
        self.emailAssociado.delegate = self;
        self.telefoneAssociado.delegate = self;
        self.placaVeiculoAssociado.delegate = self;
        self.nomeAmigo.delegate = self;
        self.telefoneAmigo.delegate = self;
        self.emailAmigo.delegate = self;
        self.emailRemetente.delegate = self;
        self.nomeAssociado.delegate = self;
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func consisteFormulario() -> Bool
    {
        //verifica se todos campos estao preenchidos
        if(codigoAssociacao.text == "" || cpfAssociado.text == "" || emailAssociado.text == "" || telefoneAssociado.text == "" ||
           placaVeiculoAssociado.text == "" || nomeAmigo.text == "" || telefoneAmigo.text == "" || emailAmigo.text == "" || emailRemetente.text == "" || nomeAssociado.text == ""){
            let alert = UIAlertController(title: "Error", message: "Preencha todos campos para enviar indicacao", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in}))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //funcao que esconde o teclado quando o usuario aperta Return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func enviarIndicacao(_ sender: UIButton) {
        //só enviar a requisicao se o formulario é valido
        if(consisteFormulario()){
            changeUIStatus(ativo: false)
            indicaAmigo()
        }
    }
    
    func changeUIStatus(ativo: Bool)
    {
        self.codigoAssociacao.isUserInteractionEnabled = ativo
        self.cpfAssociado.isUserInteractionEnabled = ativo
        self.emailAssociado.isUserInteractionEnabled = ativo
        self.telefoneAssociado.isUserInteractionEnabled = ativo
        self.placaVeiculoAssociado.isUserInteractionEnabled = ativo
        self.nomeAmigo.isUserInteractionEnabled = ativo
        self.telefoneAmigo.isUserInteractionEnabled = ativo
        self.emailAmigo.isUserInteractionEnabled = ativo
        self.emailRemetente.isUserInteractionEnabled = ativo
        self.nomeAssociado.isUserInteractionEnabled = ativo
        self.enviar.isUserInteractionEnabled = ativo
        if(ativo){
            self.activityIndicator.stopAnimating()
            self.scrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            self.activityIndicator.startAnimating()
            self.scrollView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    func printWebServiceMessage(stringTitle: String, stringError: String)
    {
        let alert = UIAlertController(title: stringTitle, message: stringError, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //reabilita a interface
            self.changeUIStatus(ativo: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func indicaAmigo(){
        let urlString: String = "http://app.hinovamobile.com.br/ProvaConhecimentoWebApi/Api/Indicacao"
        
        
        guard let url = URL(string: urlString) else {
            printWebServiceMessage(stringTitle: "Error", stringError: "Error: cannot create URL")
            return
        }
        //adiciona a url a requisicao
        var urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //adiciona o metodo post a requisicao
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //adiciona os dados dos formularios a um arquivo json
        let json: [String: Any] = ["Indicacao": ["CodigoAssociacao": self.codigoAssociacao.text!,
                                                 "DataCriacao": Date().description,
                                                 "CpfAssociado":self.cpfAssociado.text!,
                                                 "EmailAssociado":self.emailAssociado.text!,
                                                 "NomeAssociado":self.nomeAssociado.text!,
                                                 "TelefoneAssociado":self.telefoneAssociado.text!,
                                                 "PlacaVeiculoAssociado":self.placaVeiculoAssociado.text!,
                                                 "NomeAmigo": self.nomeAmigo.text!,
                                                 "TelefoneAmigo": self.telefoneAmigo.text!,
                                                 "EmailAmigo": self.emailAmigo.text!],
                                   "Remetente": self.emailRemetente.text!,
                                   "Copias":[]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // adiciona dados JSON a requisicao
        urlRequest.httpBody = jsonData
        
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error!)
                self.printWebServiceMessage(stringTitle: "Error", stringError: "error calling GET on /todos/1")
                return
            }
            // make sure we got data
            guard let responseData = data else {
                self.printWebServiceMessage(stringTitle: "Error", stringError: "Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        self.printWebServiceMessage(stringTitle: "Error", stringError: "error trying to convert data to JSON")
                        return
                }
                
                if let erro = todo["RetornoErro"] as? [String:AnyObject],
                    let erroString = erro["retornoErro"] as? String {
                    if !(erroString is NSNull) {
                        self.printWebServiceMessage(stringTitle: "Erro", stringError: erroString as! String)
                    }
                }else{
                    self.printWebServiceMessage(stringTitle: "Sucesso", stringError: todo["Sucesso"] as! String)
                }
                
                
            } catch  {
                print("error trying to convert data to JSON")
                self.printWebServiceMessage(stringTitle: "Error", stringError: "error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}
