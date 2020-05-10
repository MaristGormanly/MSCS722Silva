package com.example.frankiefilter;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
//import android.widget.TextView;

import com.google.ar.core.AugmentedFace;
import com.google.ar.core.Config;
import com.google.ar.core.Frame;
import com.google.ar.sceneform.rendering.ModelRenderable;
import com.google.ar.sceneform.rendering.Renderable;
import com.google.ar.sceneform.rendering.Texture;
import com.google.ar.sceneform.ux.AugmentedFaceNode;

import java.util.Collection;

public class MainActivity extends AppCompatActivity {

    private ModelRenderable modelRenderable;
    private Texture texture;
    private boolean added = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ARFrag arFrag = (ARFrag) getSupportFragmentManager().findFragmentById(R.id.arFragment);
        ModelRenderable.builder().setSource(this, R.raw.fox_face).build().thenAccept(renderable -> {
            modelRenderable = renderable;
            // hides shadows
            modelRenderable.setShadowCaster(false);
            modelRenderable.setShadowReceiver(false);
        });

        Texture.builder().setSource(this, R.drawable.fox_face_mesh_texture).build()
                .thenAccept(texture -> this.texture = texture);
        arFrag.getArSceneView().setCameraStreamRenderPriority(Renderable.RENDER_PRIORITY_FIRST);
        arFrag.getArSceneView().getScene().addOnUpdateListener(frameTime -> {
            if(modelRenderable == null || texture == null){
                return;
            }
            Frame frame = arFrag.getArSceneView().getArFrame();
            Collection<AugmentedFace> augmentedFaces = frame.getUpdatedTrackables(AugmentedFace.class);
            for(AugmentedFace augmentedFace : augmentedFaces){
                if(added){
                    return;
                }
                AugmentedFaceNode augmentedFaceNode = new AugmentedFaceNode(augmentedFace);
                augmentedFaceNode.setParent(arFrag.getArSceneView().getScene());
                augmentedFaceNode.setFaceRegionsRenderable(modelRenderable);
                augmentedFaceNode.setFaceMeshTexture(texture);
                added = true;
            }
        });
    }
}
