//
//  DetailOficinaViewController.swift
//  Hinova_challenge
//
//  Created by Henrique Valadares on 11/06/18.
//  Copyright © 2018 Henrique Valadares. All rights reserved.
//

import UIKit

class DetailOficinaViewController : UIViewController
{
    public var oficina: Oficina? = nil
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var descricao: UITextView!

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var avaliacaoUsuario: UILabel!
    @IBOutlet weak var codigoAssociacao: UILabel!

    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var telefone1: UILabel!
    @IBOutlet weak var telefone2: UILabel!
    @IBOutlet weak var ativo: UILabel!
    @IBOutlet weak var endereco: UITextView!
    @IBOutlet weak var descricaoCurta: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        id.text = id.text! + String(oficina!.id)
        nome.text = nome.text! + oficina!.nome
        //remove caracteres de escape da string
        descricao.text = descricao.text! + oficina!.descricao.replacingOccurrences(of: "\\n", with: "").replacingOccurrences(of: "/", with: " ")
        descricaoCurta.text = descricaoCurta.text! + oficina!.descricaoCurta
        endereco.text = endereco.text! + oficina!.endereco
        latitude.text = latitude.text! + oficina!.latitude
        longitude.text = longitude.text! + oficina!.longitude
        avaliacaoUsuario.text = avaliacaoUsuario.text! + String(oficina!.avaliacaoUsuario)
        codigoAssociacao.text = codigoAssociacao.text! + String(oficina!.codigoAssociacao)
        email.text = email.text! + oficina!.email
        telefone1.text = telefone1.text! + oficina!.telefone1
        telefone2.text = telefone2.text! + oficina!.telefone2
        ativo.text = ativo.text! + String(oficina!.ativo)
        
        //gera imagem apartir da string
        let imageData = Data(base64Encoded: (oficina?.foto)!)
        foto.image = UIImage(data: imageData!)
        
        
    }
    

    
}
