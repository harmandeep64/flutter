class NestedNavigatorExample extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: POSDrawer(),
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Expanded(
                    flex: 3,
                    child: ClipRect(
                      child: Navigator(
                        key: Get.nestedKey(Constants.loginAuthRoutesKey),
                        initialRoute: NestedRoutes.initialRoute,
                        onGenerateRoute: (settings) {
                          return NestedRoutes.routes(settings);
                        },
                      ),
                    ),
                  )
        ),
      ),
    );
  }
}