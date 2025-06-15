# 🧾 Auction Smart Contract - Trabajo Final Módulo 2

Este repositorio contiene el contrato inteligente desarrollado como parte del Trabajo Final del Módulo 2. Se trata de una **subasta descentralizada** desplegada y verificada en la red de prueba **Sepolia**.

## ✅ Funcionalidades principales

- Subasta con duración configurable (en minutos).
- Solo se aceptan ofertas válidas (superiores al menos en 5%).
- Registro de todas las ofertas.
- Posibilidad de reembolso parcial durante la subasta.
- Finalización de la subasta con devolución de depósitos no ganadores y cobro de comisión del 2%.
- Eventos emitidos en cada cambio de estado.

## 🔗 Contrato desplegado y verificado

- 📍 Dirección: [0x7c564Aa6F4a52a55371766104c4C70b13893386c](https://sepolia.etherscan.io/address/0x7c564Aa6F4a52a55371766104c4C70b13893386c#code)
- Red: Sepolia
- Compilador: Solidity 0.8.20
- Licencia: MIT

## 🧱 Estructura del contrato

### Funciones principales

- constructor(uint durationMinutes): Inicia la subasta.
- bid() payable: Realiza una oferta.
- showBids(): Devuelve la lista de oferentes y montos.
- highestBid(): Devuelve la mejor oferta.
- partialRefund(): Permite reembolsos parciales.
- finalizeAuction(): Finaliza la subasta.

### Variables públicas

- owner
- endTime
- highestBid
- bids
- deposits
- ended

### Eventos

- NewBid(address indexed bidder, uint amount)
- AuctionEnded(address winner, uint amount)

---

## 📦 Cómo desplegar

1. Usar Remix IDE: [https://remix.ethereum.org](https://remix.ethereum.org)
2. Crear archivo Auction.sol
3. Seleccionar compilador 0.8.20
4. Deployar en red Sepolia con MetaMask
5. Verificar contrato en Etherscan

---

## 🪪 Licencia

MIT License

## 🧪 Pruebas
Usar Metamask + Remix para ofertar y probar extensiones de tiempo, reembolsos y eventos.

## 👩‍💻 Autora
Gabriela Coronel - @lagabyok