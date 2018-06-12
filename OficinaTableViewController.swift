//
//  OficinaTableViewController.swift
//  Hinova_challenge
//
//  Created by Henrique Valadares on 11/06/18.
//  Copyright © 2018 Henrique Valadares. All rights reserved.
//

import UIKit

class OficinaTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var oficinas: [Oficina] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buscaOficinas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buscaOficinas(){
        let urlString: String = "http://app.hinovamobile.com.br/ProvaConhecimentoWebApi/Api/Oficina?codigoAssociacao=601&cpfAssociado="


        guard let url = URL(string: urlString) else {
            printWebServiceError(stringError: "Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)

        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error!)
                self.printWebServiceError(stringError: "error calling GET on /todos/1")
                return
            }
            // make sure we got data
            guard let responseData = data else {
                self.printWebServiceError(stringError: "Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        self.printWebServiceError(stringError: "error trying to convert data to JSON")
                        return
                }
                
                print("requisicao feita com sucesso")
                
                let oficinas = todo["ListaOficinas"] as? [[String: Any]]
                for oficina in oficinas! {
                    
                    let id = oficina["Id"]! as! Int
                    let nome = oficina["Nome"]! as! String
                    let descricao = oficina["Descricao"]! as! String
                    let descricaoCurta = oficina["DescricaoCurta"]! as! String
                    let endereco = oficina["Endereco"]! as! String
                    let latitude = oficina["Latitude"]! as! String
                    let longitude = oficina["Longitude"]! as! String
                    
                    let foto = oficina["Foto"]! as! String
                    let avaliacaoUsuario = oficina["AvaliacaoUsuario"]! as! Int
                    let codigoAssociacao = oficina["CodigoAssociacao"]! as! Int
                    let email = oficina["Email"]! as! String
                    let ativo = oficina["Ativo"]! as! Bool
                   
                    var telefone1:String = ""
                    
                    if !(oficina["Telefone1"] is NSNull) {
                        telefone1 = oficina["Telefone1"]! as! String
                    }
                    
                    var telefone2:String = ""
                    
                    if !(oficina["Telefone2"] is NSNull) {
                        telefone2 = oficina["Telefone2"]! as! String
                    }
 
                    
                    self.oficinas.append(Oficina(id: id, nome: nome, descricao: descricao, descricaoCurta: descricaoCurta, endereco: endereco, latitude: latitude, longitude: longitude, foto: foto, avaliacaoUsuario: avaliacaoUsuario, codigoAssociacao: codigoAssociacao, email: email, telefone1: telefone1, telefone2: telefone2, ativo: ativo))
                    
                }
                
                DispatchQueue.main.async {
                    //pára o indicador de atividades
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
                
            } catch  {
                print("error trying to convert data to JSON")
                self.printWebServiceError(stringError: "error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    

    
    func printWebServiceError(stringError: String)
    {
        let alert = UIAlertController(title: "Error", message: stringError, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //execute some code when this option is selected
            self.activityIndicator.stopAnimating()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oficinas.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = oficinas[indexPath.row].nome
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as? DetailOficinaViewController
                var oficina:Oficina = oficinas[indexPath.row]
                controller?.oficina = oficina
           }
        }
      }

}

    

