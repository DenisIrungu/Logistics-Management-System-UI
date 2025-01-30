import 'package:flutter/material.dart';
import 'package:logistcs/components/mycontainer.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,  
        centerTitle: true,
        title: Text('OnBoarding', 
        style: TextStyle(fontSize: 25, color: Color(0xFFFFFFFF)),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          Center(
            child: Text('Please Select you Role', 
            style: TextStyle(
              color:Theme.of(context).colorScheme.surface, 
              fontSize: 18, fontWeight: 
              FontWeight.bold),),
          ),
          SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/signinscreen');
            },
            child: MyContainer(text: 'Admin')),
          SizedBox(height: 50),
          MyContainer(text: 'Rider'),
          SizedBox(height: 50),
          MyContainer(text: 'Agent'),
          SizedBox(height: 50),
          MyContainer(text: ('Customer'),)
        ],
      ),
      
    );
  }
}