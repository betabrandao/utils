body {
	width: 100wh;
	height: 90vh;
	color: #fff;
	background: radial-gradient(circle, rgba(237,12,101,1) 0%, rgba(115,179,255,1) 50%, rgba(239,100,161,1) 100%);
	background-size: 400% 400%;
	-webkit-animation: Gradient 150s ease infinite;
	-moz-animation: Gradient 150s ease infinite;
	animation: Gradient 150s ease infinite;
}

@-webkit-keyframes Gradient {
	0% {
		background-position: 0% 50%
	}
	50% {
		background-position: 100% 50%
	}
	100% {
		background-position: 0% 50%
	}
}

@-moz-keyframes Gradient {
	0% {
		background-position: 0% 50%
	}
	50% {
		background-position: 100% 50%
	}
	100% {
		background-position: 0% 50%
	}
}

@keyframes Gradient {
	0% {
		background-position: 0% 50%
	}
	50% {
		background-position: 100% 50%
	}
	100% {
		background-position: 0% 50%
	}
}

h1,
h6 {
	font-family: 'Open Sans';
	font-weight: 300;
	text-align: center;
	position: absolute;
	top: 45%;
	right: 0;
	left: 0;
}

.shake {
	animation: shake-animation 4.72s ease infinite;
	transform-origin: 50% 50%;
  }
  .element {
	margin: 0 auto;
	width: 150px;
	height: 150px;
	background: red;
  }
  @keyframes shake-animation {
	 0% { transform:translate(0,0) }
	1.78571% { transform:translate(5px,0) }
	3.57143% { transform:translate(0,0) }
	5.35714% { transform:translate(5px,0) }
	7.14286% { transform:translate(0,0) }
	8.92857% { transform:translate(5px,0) }
	10.71429% { transform:translate(0,0) }
	100% { transform:translate(0,0) }
  }

  .backdrop {
	  -moz-box-shadow: 0px 6px 5px #111; 
	  -webkit-box-shadow: 0px 6px 5px #111; 
	  box-shadow: 0px 2px 10px #111; 
	  -moz-border-radius:190px; 
	  -webkit-border-radius:190px; 
	  border-radius:190px;
  }

  .linktree {
	  width: 120px;
	  height: 120px;
	  background-image: url("image.png");
	  background-size: cover;
	  background-repeat: no-repeat;
	  background-position: 50% 50%;
  }

.card {
    width: 51rem!important;
}

.audio {
    width: 49rem!important;
}

@media only screen and (max-width: 768px) {
.card {
    width: 20rem!important;
}
.audio {
    width: 18rem!important;
}
}

