unit TestRawShapeJsonConverter;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, System.SysUtils, uSoTypes, uRawShapes, System.JSON, uGeometryClasses,
  uRawShapeBaseConverter, uRawShapeJsonConverter, uJsonUtils, System.Math, System.Types,
  uTestRawShapesContructors;

type
  // Test methods for class TRawShapeJsonConverter

  TestTRawShapeJsonConverter = class(TTestCase)
  strict private
    FRawShapeJsonConverter: TRawShapeJsonConverter;
    function IsPointArrayEquals(const AArr1, AArr2: TArray<TPointF>): Boolean;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConvertFromCirce;
    procedure TestConvertFromPoly;
    procedure TestConvertToCirce;
    procedure TestConvertToPoly;
  end;

implementation

function TestTRawShapeJsonConverter.IsPointArrayEquals(const AArr1,
  AArr2: TArray<TPointF>): Boolean;
var
  i: Integer;
begin
  if Length(AArr1) <> Length(AArr2) then
    Exit(False);

  for i := 0 to High(AArr1) do
    if (AArr1[i].X <> AArr2[i].X) or (AArr1[i].X <> AArr2[i].X)  then
      Exit(False);

  Result := True;
end;

procedure TestTRawShapeJsonConverter.SetUp;
begin
  FRawShapeJsonConverter := TRawShapeJsonConverter.Create;
end;

procedure TestTRawShapeJsonConverter.TearDown;
begin
  FRawShapeJsonConverter.Free;
  FRawShapeJsonConverter := nil;
end;

procedure TestTRawShapeJsonConverter.TestConvertFromCirce;
var
  ReturnValue: TRawShape;
  AObject: TJSONValue;
begin
  AObject := TRawShapesContructor.CreateJsonCircle(25, -25, 127);

  ReturnValue := FRawShapeJsonConverter.ConvertFrom(AObject);
  Check(
   (SameValue(ReturnValue.GetData[0].X, 25)) and
   (SameValue(ReturnValue.GetData[0].Y, -25)) and
   (SameValue(ReturnValue.GetData[1].X, 127)) and
   (ReturnValue.FigureType = ftCircle),
   'Convert from JsonCircle unsuccesful'
  );
end;

procedure TestTRawShapeJsonConverter.TestConvertFromPoly;
var
  ReturnValue: TRawShape;
  AObject: TJSONValue;
begin
  AObject := TRawShapesContructor.CreateJsonPoly([3,7,5,9,-50, -50, 100, 110]);

  ReturnValue := FRawShapeJsonConverter.ConvertFrom(AObject);
  Check(
   (SameValue(ReturnValue.GetData[0].X, 3)) and
   (SameValue(ReturnValue.GetData[0].Y, 7)) and
   (SameValue(ReturnValue.GetData[1].X, 5)) and
   (SameValue(ReturnValue.GetData[1].Y, 9)) and
   (SameValue(ReturnValue.GetData[2].X, -50)) and
   (SameValue(ReturnValue.GetData[2].Y, -50)) and
   (SameValue(ReturnValue.GetData[3].X, 100)) and
   (SameValue(ReturnValue.GetData[3].Y, 110)) and
   (ReturnValue.FigureType = ftPoly),
   'Convert from JsonPoly unsuccesful'
  );
end;

procedure TestTRawShapeJsonConverter.TestConvertToCirce;
var
  ReturnValue: TJSONValue;
  AShape: TRawShape;
  vR: Single;
  vP: TPointF;
  vType: string;
  vVal: TJSONValue;
  vS: string;
begin
  AShape := TRawShapesContructor.CreateRawCircle(-3, 73, 102);

  ReturnValue := FRawShapeJsonConverter.ConvertTo(AShape);

  if ReturnValue.TryGetValue('Center', vVal) then
    vP := JsonToPointF(vVal);

  if ReturnValue.TryGetValue('Radius', vVal) then
    vR := JsonToSingle(vVal);

  if ReturnValue.TryGetValue('Type', vVal) then
    vType := JsonToString(vVal);

 Check(
   (SameValue(vP.X, -3)) and
   (SameValue(vP.Y, 73)) and
   (SameValue(vR, 102)) and
   (vType = 'Circle'),
   'Convert to RawCircle unsuccesful'
  );
end;

procedure TestTRawShapeJsonConverter.TestConvertToPoly;
var
  ReturnValue: TJSONValue;
  AShape: TRawShape;
  vJArr: TJSONArray;
  vVal: TJSONValue;
  i: Integer;
  vArr: TArray<TPointF>;
  vS: string;
begin
  AShape := TRawShapesContructor.CreateRawPoly([50, -50, -50, -50, -50, 60, 60, 60]);

  ReturnValue := FRawShapeJsonConverter.ConvertTo(AShape);

  if ReturnValue.TryGetValue('Points', vJArr) then
    vArr := JsonToPointFArray(vJArr);

  Check(
    IsPointArrayEquals(AShape.GetData, vArr),
    'Convert to RawPoly unsuccesful'
  );
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTRawShapeJsonConverter.Suite);
end.


