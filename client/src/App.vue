<template>
   <div class="app">
      <header class="navbar">
         <div class="navbar__title">
            <p class="navbar-text">Tickets app</p>
         </div>
         <div class="navbar__address">
            <p class="navbar-text">{{account}}</p>
         </div>
      </header>
      <section class="card-canvas card-wrapper">
         <div v-for="ticket in tickets" class="ticket card">
            <img class="card__img" src="https://community.akamai.steamstatic.com/economy/image/fWFc82js0fmoRAP-qOIPu5THSWqfSmTELLqcUywGkijVjZULUrsm1j-9xgEGegouSRLhsz1Xt8TnH_WJRuNVy49itMUB32JtklgoN7OzZTQxJFPEV_lfBa1irV-9C3Zr6sU6AdH457UBdvwbXdU/360fx360f" alt="Ticket image" style="width:100%;">
            
            <div class="card__description">
               <div class="card__text-container">
                  <h4><b>Ticket {{ ticket.id }}</b></h4>
                  <p>Price: ~{{ ticket.price }} ETH</p>
               </div>
               <div class="card__button-container">
                  <button @click="buyTickets(ticket)" class="card__buy-button">Buy</button>
               </div>
            </div>
         </div>
      </section>
   </div>
</template>

<script>
import Web3 from 'web3';
import configuration from '../../build/contracts/Tickets.json';

export default {
   name: 'App',

   components: {

   },

   data() {
      return {
         test: [],
         isConnected: window.ethereum ? true : false,
         contractResult: '',
         CONTRACT_ADDRESS: configuration.networks['5777'].address,
         CONTRACT_ABI: configuration.abi,
         TOTAL_TICKETS: 10,
         EMPTY_ADDRESS: '0x0000000000000000000000000000000000000000',
         account: '',
         contract: null,
         tickets: [],
      }
   },

   // lifecycle methods
   created() {
      console.clear();
      (async () => {
         await this.showAddress();
         await this.refreshTickets();
      })();
   },

   mounted() {
      console.log('Mounted');
   },

   onUpdated() {
      console.log('Updated');
   },


   methods: {
      showAddress: async function() {
         const web3 = new Web3(
            // ganache test blockchain
            Web3.givenProvider || 'http://127.0.0.1:7545'
         );
         this.contract = new web3.eth.Contract(this.CONTRACT_ABI, this.CONTRACT_ADDRESS);
         const accounts = await web3.eth.requestAccounts();
         this.account = accounts[0];
      },
      refreshTickets: async function(isBought = false) {
         if(isBought) {
            this.tickets.length = 0;
         }
         for(let i = 0; i < this.TOTAL_TICKETS; i++) {
            const ticket = await this.contract.methods.tickets(i).call();
            // ticket.id = i;
            // ticket.price = Math.floor(Math.random() * 10000);
            if(ticket.owner === this.EMPTY_ADDRESS) {
               this.tickets.push(ticket);
            }
         }
         for(let i = 0; i < 10; i++) {
            const ticket = await this.contract.methods.tickets(1).call();
            this.test.push(ticket);
         }
      },
      buyTickets: async function(ticket) {
         await this.contract.methods.buyTicket(ticket.id).send({
            from: this.account,
            value: ticket.price,
         });
         // В refresh передаем флаг true для правильной повторной отрисовки билетов
         await this.refreshTickets(true);
      }
   }
}
</script>

<style scoped>
   button {
      font-weight: bold;
   }

   .navbar {
   height: 50px;
   background-color: black;
   display: flex;
   flex-direction: row;
   justify-content: space-between;
}


.navbar-text {
   color: aliceblue;
}

.navbar__title,
.navbar__address {
   display: flex;
   flex-direction: column;
   align-items: center;
   justify-content: center;
   font-family: serif;
}

.navbar__title p {
   margin-left: 20px;
   font-size: 32px;
   cursor: pointer;
}

.card-canvas {
   display: flex;
   flex-direction: row;
   flex-wrap: wrap;
   /* margin: 0 2rem 0 2rem; */
   justify-content: center;
}

.card {
   box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
   transition: 0.3s;
   border-radius: 5px;
   margin: 10px;
}

.card:hover {
   box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
}

.card__description {
   display: flex;
}

.card__text-container {
   padding: 2px 16px 16px 16px;
}

.card__button-container {
   display: flex;
   justify-content: flex-end;
   flex: 1 1 auto;
}

.card__buy-button {
   border-radius: 8px;
   border: 1px solid transparent;
   padding: 0.6em 1.2em;
   font-size: 1em;
   font-weight: 500;
   font-family: inherit;
   background-color: transparent;
   cursor: pointer;
   transition: border-color 0.25s;
   border-color: #5056b1;
   font-weight: bold;
   margin: 0 15px 15px 0;
   /* transform: scale(1.0); */
   -webkit-transition: .55s ease;
   /* Safari and Chrome */
   -moz-transition: .55s ease;
   /* Firefox 4 */
   -o-transition: .55s ease;
   /* Opera */
}

.card__buy-button:hover {
   transition: all ease .25s;
   /* transform: scale(1.0); */
   border-color: #515cfa;
   background-color: #515cfa;
   color: #001F3F;
}

.card__buy-button:focus,
.card__buy-button:focus-visible {
   outline: 4px auto -webkit-focus-ring-color;
}

.card__img {
   border-radius: 5px 5px 0 0;
}
</style>