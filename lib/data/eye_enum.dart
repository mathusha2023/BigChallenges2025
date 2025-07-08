enum EyeEnum { left, right }

String eyeToString(EyeEnum eye) => eye == EyeEnum.left ? "Левый" : "Правый";
EyeEnum stringToEye(String eye) =>
    eye == "Левый" ? EyeEnum.left : EyeEnum.right;
